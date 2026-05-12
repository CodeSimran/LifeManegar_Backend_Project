# LifeManager - Personal Financial Management Application

A comprehensive web-based personal finance management system built with Java Servlets, JSP, and MySQL. Manage expenses, track cards, documents, and monitor your financial status all in one place.

## 🎯 Features

- **User Management**
  - User registration with email validation
  - Secure login authentication
  - User profile management

- **Expense Tracking**
  - Add, view, edit, and delete expenses
  - Categorize expenses
  - Track payment status
  - View expense history

- **Card Management**
  - Add and manage payment cards
  - Track card details
  - Monitor card usage

- **Document Management**
  - Upload and manage financial documents
  - Organize documents by category
  - Easy document retrieval

- **Dashboard**
  - Overview of financial status
  - Quick statistics
  - Recent transactions

## 🛠 Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **Backend** | Java Servlets | 17.0.18 |
| **Frontend** | JSP, HTML, CSS | - |
| **Build Tool** | Maven | 3.9.15 |
| **Server** | Jetty | 11.0.19 |
| **Database** | MySQL | via mysql-connector-j 8.3.0 |
| **API** | Jakarta Servlet API | 6.0.0 |

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Java Development Kit (JDK)** 17 or higher
  - Download: https://adoptium.net/
  - Or use: `java -version` to check

- **Maven** 3.8.9 or higher
  - Download: https://maven.apache.org/download.cgi
  - Or use: `mvn -v` to check

- **MySQL Server** 5.7 or higher
  - Download: https://dev.mysql.com/downloads/mysql/
  - Service should be running

- **Git** (optional, for version control)

## 🚀 Getting Started

### 1. Clone or Download the Project

```bash
git clone <repository-url>
cd LifeManager
```

### 2. Configure Database

Create a MySQL database and update the connection settings:

**File:** `src/main/java/com/util/DBConnection.java`

```java
private static final String URL = "jdbc:mysql://localhost:3306/lifemanager";
private static final String USER = "root";
private static final String PASSWORD = "your_password";
```

**Create Database and Tables:**

```sql
CREATE DATABASE lifemanager;
USE lifemanager;

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Expenses table
CREATE TABLE expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50),
    description VARCHAR(255),
    payment_status VARCHAR(20) DEFAULT 'Pending',
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Cards table
CREATE TABLE cards (
    card_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    card_number VARCHAR(20) NOT NULL,
    card_holder_name VARCHAR(100),
    expiry_date VARCHAR(5),
    cvv VARCHAR(4),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Documents table
CREATE TABLE documents (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500),
    category VARCHAR(50),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```

### 3. Build the Project

```bash
mvn clean package
```

This will:
- Download all dependencies
- Compile Java source code
- Run tests (if any)
- Create a WAR file: `target/LifeManager.war`

### 4. Run the Application

```bash
mvn jetty:run
```

The application will start on: **http://localhost:8080**

**Expected Output:**
```
[INFO] Started ServerConnector@...{HTTP/1.1, (http/1.1)}{0.0.0.0:8080}
[INFO] Started Server@...
```

### 5. Access the Application

Open your browser and navigate to:

- **Home:** http://localhost:8080
- **Login:** http://localhost:8080/login.jsp
- **Register:** http://localhost:8080/register.jsp
- **Dashboard:** http://localhost:8080/dashboard.jsp (after login)

## 📁 Project Structure

```
LifeManager/
├── pom.xml                           # Maven configuration
├── README.md                         # This file
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       ├── controller/       # Servlet controllers
│   │   │       │   ├── LoginServlet.java
│   │   │       │   ├── RegisterServlet.java
│   │   │       │   ├── DashboardServlet.java
│   │   │       │   ├── AddExpenseServlet.java
│   │   │       │   ├── EditExpenseServlet.java
│   │   │       │   ├── DeleteExpenseServlet.java
│   │   │       │   ├── UpdateExpenseServlet.java
│   │   │       │   ├── UpdateStatusServlet.java
│   │   │       │   ├── AddCardServlet.java
│   │   │       │   └── DocumentServlet.java
│   │   │       ├── dao/              # Data Access Objects
│   │   │       │   ├── UserDAO.java
│   │   │       │   ├── UserDAOImpl.java
│   │   │       │   ├── ExpenseDAO.java
│   │   │       │   ├── ExpenseDAOImpl.java
│   │   │       │   ├── CardDAO.java
│   │   │       │   ├── CardDAOImpl.java
│   │   │       │   ├── DocumentDAO.java
│   │   │       │   └── DocumentDAOImpl.java
│   │   │       ├── model/            # Data models
│   │   │       │   ├── User.java
│   │   │       │   ├── Expense.java
│   │   │       │   ├── Card.java
│   │   │       │   └── Document.java
│   │   │       └── util/             # Utility classes
│   │   │           └── DBConnection.java
│   │   ├── resources/                # Resource files
│   │   └── webapp/                   # Web application files
│   │       ├── WEB-INF/
│   │       │   └── web.xml          # Deployment descriptor
│   │       ├── index.jsp             # Home page
│   │       ├── login.jsp             # Login page
│   │       ├── register.jsp          # Registration page
│   │       ├── dashboard.jsp         # Dashboard page
│   │       ├── expenses.jsp          # Expenses page
│   │       ├── addexpense.jsp        # Add expense page
│   │       ├── editexpense.jsp       # Edit expense page
│   │       ├── cards.jsp             # Cards management page
│   │       ├── deletecard.jsp        # Delete card page
│   │       └── document.jsp          # Documents page
│   └── test/                         # Test files
│       ├── java/
│       └── resources/
├── target/                           # Build output
│   ├── classes/                      # Compiled classes
│   ├── LifeManager.war               # Deployable WAR file
│   └── ...
└── .git/                             # Git version control
```

## 🔧 Servlets and Endpoints

| Servlet | URL | Method | Purpose |
|---------|-----|--------|---------|
| LoginServlet | /login | POST | Authenticate user |
| RegisterServlet | /register | POST | Create new user account |
| DashboardServlet | /dashboard | GET | Fetch dashboard data |
| AddExpenseServlet | /addExpense | POST | Create new expense |
| EditExpenseServlet | /editExpense | GET/POST | Update expense details |
| DeleteExpenseServlet | /deleteExpense | POST | Remove expense |
| UpdateExpenseServlet | /updateExpense | POST | Update expense status |
| UpdateStatusServlet | /updateStatus | POST | Change payment status |
| AddCardServlet | /addCard | POST | Add payment card |
| DocumentServlet | /document | GET/POST | Manage documents |

## 💾 Database Schema

### Users Table
- `user_id` (INT, Primary Key)
- `full_name` (VARCHAR)
- `email` (VARCHAR, Unique)
- `phone_number` (VARCHAR)
- `password` (VARCHAR)
- `created_at` (TIMESTAMP)

### Expenses Table
- `expense_id` (INT, Primary Key)
- `user_id` (INT, Foreign Key)
- `amount` (DECIMAL)
- `category` (VARCHAR)
- `description` (VARCHAR)
- `payment_status` (VARCHAR)
- `date` (TIMESTAMP)

### Cards Table
- `card_id` (INT, Primary Key)
- `user_id` (INT, Foreign Key)
- `card_number` (VARCHAR)
- `card_holder_name` (VARCHAR)
- `expiry_date` (VARCHAR)
- `cvv` (VARCHAR)
- `created_at` (TIMESTAMP)

### Documents Table
- `document_id` (INT, Primary Key)
- `user_id` (INT, Foreign Key)
- `file_name` (VARCHAR)
- `file_path` (VARCHAR)
- `category` (VARCHAR)
- `uploaded_at` (TIMESTAMP)

## 🔐 Security Notes

⚠️ **Important for Production:**
- Hash passwords using bcrypt or similar algorithms
- Use HTTPS instead of HTTP
- Implement CSRF protection
- Validate and sanitize all user inputs
- Use prepared statements to prevent SQL injection (already implemented)
- Implement session management with secure cookies
- Add role-based access control (RBAC)

## 🧪 Testing

Run unit tests:

```bash
mvn test
```

Run integration tests:

```bash
mvn verify
```

## 📦 Deployment

### Deploy to Tomcat

1. Build the WAR file:
   ```bash
   mvn clean package
   ```

2. Copy to Tomcat:
   ```bash
   cp target/LifeManager.war $CATALINA_HOME/webapps/
   ```

3. Start Tomcat:
   ```bash
   $CATALINA_HOME/bin/startup.sh
   ```

### Deploy to Other Servers

The `target/LifeManager.war` file can be deployed to any servlet container (Tomcat, JBoss, Jetty, etc.).

## 🐛 Troubleshooting

### Port 8080 Already in Use

```bash
# Kill the process using port 8080
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Or use a different port
mvn jetty:run -Djetty.port=8081
```

### Database Connection Error

Check `DBConnection.java`:
- Verify MySQL is running
- Confirm database name, username, password
- Ensure MySQL connector is in classpath (it is via Maven)

### Maven Build Fails

```bash
# Clear Maven cache and rebuild
mvn clean install -U
```

## 📝 Usage Workflow

1. **Register an Account**
   - Go to http://localhost:8080/register.jsp
   - Fill in your details
   - Click Register

2. **Login**
   - Go to http://localhost:8080/login.jsp
   - Enter your credentials
   - You'll be redirected to dashboard

3. **Manage Expenses**
   - Click on "Expenses" in dashboard
   - Add, edit, or delete expenses
   - Update payment status

4. **Manage Cards**
   - Click on "Cards" in dashboard
   - Add payment cards
   - View and manage card details

5. **Upload Documents**
   - Click on "Documents" in dashboard
   - Upload financial documents
   - Organize by category

## 🔄 Development Workflow

1. Make code changes in `src/main/java`
2. Make JSP changes in `src/main/webapp`
3. Maven will auto-recompile with `mvn jetty:run`
4. Refresh your browser to see changes

## 📚 Dependencies

All dependencies are managed by Maven (see `pom.xml`):

- **jakarta.servlet:jakarta.servlet-api** - Servlet API
- **javax.servlet:javax.servlet-api** - Legacy Servlet API
- **com.mysql:mysql-connector-j** - MySQL JDBC Driver
- **junit:junit** - Testing framework

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Commit and push
5. Create a Pull Request

## 📄 License

This project is provided as-is. Modify and use as needed for your requirements.

## 📞 Support

For issues or questions:
1. Check the troubleshooting section
2. Review the source code comments
3. Check database connection settings
4. Verify all dependencies are installed

## 🎓 Learning Resources

- [Java Servlets Documentation](https://jakarta.ee/specifications/servlet/)
- [JSP Tutorial](https://www.oracle.com/java/technologies/jsppref.html)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Maven Documentation](https://maven.apache.org/guides/)
- [Jetty Documentation](https://www.eclipse.org/jetty/documentation.html)

---

**Last Updated:** May 12, 2026  
**Version:** 1.0.0  
**Status:** Active Development
