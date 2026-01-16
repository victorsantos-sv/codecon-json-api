require "sinatra/base"
require "json"
require_relative "../../lib/memory_store"

class UsersController < Sinatra::Base
    configure do
        set :store, MemoryStore.new
    end
    
    before do
        content_type :json
    end

    helpers do
        def store = settings.store
    end

    post "/users" do
        halt 400, "File not provided" unless params[:file]
        tempfile = params[:file][:tempfile]
        content = tempfile.read

        data = JSON.parse(content, symbolize_names: true)

        data.each do |user|
            store.add(user)
        end

        status 201

        {
            message: "Arquivo recebido com sucesso",
            user_count: data.count
        }.to_json
    end

    # Superusers endpoint
    get "/superusers" do
        start_time = Time.now
        superusers = get_superusers
        halt 404 unless superusers

        processing_time_ms = (Time.now - start_time) * 1000

        {
            timestamp: Time.now,
            processing_time_ms: ("%.2f" % processing_time_ms).to_f,
            data: superusers,
        }.to_json
    end

    get "/top-countries" do
        start_time = Time.now
        
        # Filter superusers and group by country
        superusers = get_superusers
        grouped_by_country = superusers.group_by{ |user| user[:country] }
        
        # Get top 5 countries by count
        top_countries = grouped_by_country
            .map{ |country, users| { country: country, count: users.count } }
            .sort_by{ |item| -item[:count] }
            .first(5)
        
        halt 404 if top_countries.empty?

        processing_time_ms = (Time.now - start_time) * 1000

        {
            timestamp: Time.now,
            processing_time_ms: ("%.2f" % processing_time_ms).to_f,
            countries: top_countries,
        }.to_json
    end

    get "/team-insights" do
        start_time = Time.now

        users_by_team = store.all.group_by{ |user| user[:team][:name] }
        halt 404 if users_by_team.empty?

        insights = users_by_team.map do |team_name, users|
            total_members = users.count
            leaders = users.count{ |user| user[:team][:leader] }
            
            completed_projects = users.sum{ |user| user[:team][:projects].count{ |project| project[:completed] } }
            
            active_members = users.count{ |user| user[:active] }
            percentage_active = total_members > 0 ? (active_members.to_f / total_members.to_f) * 100 : 0.0

            {
                team: team_name,
                total_members: total_members,
                leaders: leaders,
                completed_projects: completed_projects,
                percentage_active: ("%.2f" % percentage_active).to_f,
            }
        end

        processing_time_ms = (Time.now - start_time) * 1000

        {
            timestamp: Time.now,
            processing_time_ms: ("%.2f" % processing_time_ms).to_f,
            teams: insights,
        }.to_json
    end

    get "/active-users-per-day" do
        start_time = Time.now

        user = store.find_by_id("c5cf0168-2ad6-405e-a384-8c38563cf40a")

        logins = store.all.map { | user| user[:logs] }
            .flat_map(&:itself)
            .group_by{|log| log[:date]}
        active_users_per_day = logins.transform_values(&:count)
            .sort_by {|date, _| date}
            .map do | date, total|
                {
                    date: date,
                    total: total
                }
            end
            
        processing_time_ms = (Time.now - start_time) * 1000

        {
            timestamp: Time.now,
            processing_time_ms: ("%.2f" % processing_time_ms).to_f,
            logins: active_users_per_day
        }.to_json
    end

    private def get_superusers
        store.all.select{ |user| user[:score] >= 900 && user[:active] }
    end
end
