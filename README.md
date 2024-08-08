# Trip Management API

## Overview

This is a Rails API-only application for managing work trips. Users can create, reassign, check in, and check out trips. The API supports basic JWT authentication for secure access.

## Prerequisites

- Ruby 3.1 or later
- Rails 7.0 or later
- PostgreSQL (or another supported database)

## Setup and Running the Server

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-directory>
```

###  2. Install Dependencies
Ensure you have bundler installed, then run:

```
bundle install
```

### 3. Set Up the Database
Create and migrate the database:
```bash
rails db:create
rails db:migrate
````
If you need sample data, you can also seed the database:

```bash
rails db:seed
```
### 4. Configure Environment Variables
Create a `.env` file in the root directory of the project and add the required environment variables. For JWT authentication, you may need:

```
SECRET_KEY_BASE=your_secret_key_base
```
Default value is set in secrets.yml

### 5. Start the Rails Server
Run the server:

```
rails s
```
The API server will be available at http://localhost:3000.

## API Endpoints

### Get Token
- Endpoint: `POST /api/v1/login`

- Request Body:

```
    {"email": "user1@example.com"}
```
- Response:
```
{
    "token": "eyJhbGciOiJIUzI1NiJ9_sample_jwt_token"
}
```

### Create a Trip
- Endpoint: `POST /api/v1/trips`
- Headers:
    - Authorization: `Bearer <jwt_token}>`
- Request Body:

```
    {
      "assignee_id": 2,
      "status": "Unstarted",
      "estimated_arrival": "2024-08-10T08:00:00Z",
      "estimated_completion": "2024-08-10T17:00:00Z"
    }
```


### Get Trips
This action will return list of trips and trip versions which are related to(Assignee or Owner) LoggedIn User.
- Endpoint: `GET /api/v1/trips`
- Headers:
    - Authorization: `Bearer <jwt_token}>`
- Authentication Required: Yes

### Get Trip Versions
This action will return list versions in a given trip where logged In user is Owner or Assignee.
- Endpoint: `GET /api/v1/trips/:id/trip_versions`
- Headers:
    - Authorization: `Bearer <jwt_token}>`
- Authentication Required: Yes

### Check In a Trip
- Endpoint: `PATCH /api/v1/trips/:id/check_in`
- Headers:
    - Authorization: `Bearer <jwt_token}>`

### Check Out a Trip
- Endpoint: `PATCH /api/v1/trips/:id/check_out`
- Headers:
    - Authorization: `Bearer <jwt_token}>`

### Reassign a Trip
- Endpoint: `PATCH /api/v1/trips/:id/reassign`
- Headers:
    - Authorization: `Bearer <jwt_token}>`

- Request Body:
```
    {
      "assignee_id": 3
    }
```

#### JWT Authentication
### How It Works
JWT authentication is used to secure the API endpoints. The token must be included in the `Authorization` header of the request.

##### Example
```
curl -H "Authorization: Bearer <your_jwt_token>" http://localhost:3000/api/v1/trips
```
