# CodeCon JSON API

A Ruby on Rails learning project focused on creating a performant API that receives a JSON file with 100,000 users and provides well-structured, high-performance endpoints for data analysis.

## 📋 Overview

This project is designed to handle large-scale user data processing with a focus on performance optimization. The API processes user data stored in memory and provides various analytical endpoints that must respond in under 1 second.

## 🎯 Project Goals

- Learn Ruby on Rails best practices
- Optimize API performance for large datasets (100,000+ users)
- Implement clean, modular, and maintainable code
- Create well-structured endpoints for data analysis

## 📚 Resources

- [Expected API Response Examples](https://github.com/codecon-dev/desafio-1-1s-vs-3j/blob/main/exemplos-endpoints.json)
- [100,000 users JSON file for import](https://drive.google.com/file/d/1zOweCB2jidgHwirp_8oBnFyDgJKkWdDA/view?usp=sharing)
- [1,000 users JSON file for testing](https://drive.google.com/file/d/1BX03cWxkvB_MbZN8_vtTJBDGiCufyO92/view?usp=sharing)

## 📊 JSON Input Structure

The API accepts a JSON array of users with the following structure:

```json
{
  "id": "uuid",
  "name": "string",
  "age": "int",
  "score": "int",
  "active": "bool",
  "country": "string",
  "team": {
    "name": "string",
    "leader": "bool",
    "projects": [{ "name": "string", "completed": "bool" }]
  },
  "logs": [{ "date": "YYYY-MM-DD", "action": "login/logout" }]
}
```

## 🚀 API Endpoints

### `POST /users`

Receives and stores users in memory. Can simulate an in-memory database.

**Request Body:**

- JSON array of user objects

**Response:**

- JSON with processing time and timestamp

---

### `GET /superusers`

Returns users that meet the superuser criteria.

**Filters:**

- `score >= 900`
- `active = true`

**Response:**

- Filtered user data
- `processing_time_ms`: Processing time in milliseconds
- `timestamp`: Request timestamp (ISO 8601 format)

---

### `GET /top-countries`

Groups superusers by country and returns the top 5 countries with the highest number of superusers.

**Response:**

- Top 5 countries with superuser counts
- `processing_time_ms`: Processing time in milliseconds
- `timestamp`: Request timestamp

---

### `GET /team-insights`

Groups users by team name and provides insights for each team.

**Response includes for each team:**

- Total members
- Number of leaders
- Number of completed projects
- Percentage of active members
- `processing_time_ms`: Processing time in milliseconds
- `timestamp`: Request timestamp

---

### `GET /active-users-per-day`

Counts how many logins occurred per date.

**Query Parameters:**

- `min` (optional): Filter days with at least the specified number of logins
  - Example: `?min=3000` filters days with at least 3,000 logins

**Response:**

- Login counts per date
- `processing_time_ms`: Processing time in milliseconds
- `timestamp`: Request timestamp

---

### `GET /evaluation`

Executes a self-evaluation of the main API endpoints and returns a scoring report.

**Tests performed:**

- HTTP status code validation (200)
- Response time measurement (milliseconds)
- JSON validity verification

**Response:**

- JSON report with test results and scores
- Used for automated and fast delivery validation

## ⚡ Technical Requirements

### Performance

- **Response time < 1 second per endpoint** (critical requirement)
- All endpoints must return:
  - `processing_time_ms`: Processing time in milliseconds
  - `timestamp`: Request timestamp (ISO 8601 format recommended)

### Code Quality

- Clean, modular code
- Well-defined functions
- Follow Ruby on Rails conventions
- Use appropriate Rails patterns (controllers, services, models, etc.)

### Response Format

All endpoints return JSON in a consistent format:

```json
{
  "data": { ... },
  "processing_time_ms": 123,
  "timestamp": "2024-01-01T12:00:00Z"
}
```

## 🏗️ Architecture

### Code Organization

- **Controllers**: Handle HTTP requests and responses
- **Service Objects**: Contain business logic for complex operations
- **Models**: Data structures (in-memory storage)
- **Serializers/Jbuilder**: JSON response formatting

### Best Practices

- Keep controllers thin - delegate business logic to service objects
- Use efficient data structures for fast lookups
- Minimize N+1 queries and optimize data processing
- Consider caching strategies for performance
- Use proper error handling and status codes

## 🧪 Testing

The `/evaluation` endpoint provides automated testing capabilities:

- Tests all main endpoints
- Validates JSON responses
- Verifies response times meet the < 1s requirement
- Supports testing with both small (1k) and large (100k) datasets

## 📝 Notes

- This is a learning project focused on Rails patterns and performance optimization
- The project uses in-memory storage (simulating a database)
- Performance is critical - all endpoints must respond in < 1 second
- Code should demonstrate Rails best practices while maintaining readability

## 🔧 Installation & Setup

_Details to be added later..._

## 📄 License

_To be determined..._
