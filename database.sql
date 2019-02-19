CREATE TABLE Users ( 
    user_email TEXT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    password TEXT NOT NULL
);

CREATE TABLE Feed (
    postID INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TEXT NOT NULL,
    user_email TEXT NOT NULL,
    mealID TEXT NOT NULL,
    rating INTEGER NOT NULL,
    comment TEXT NOT NULL
);

CREATE TABLE Followers (
    followerID INTEGER PRIMARY KEY AUTOINCREMENT,
    user_email TEXT NOT NULL,
    following_email TEXT NOT NULL,
    FOREIGN KEY (user_email) REFERENCES Users(user_email),
    FOREIGN KEY (following_email) REFERENCES Users(user_email)
);