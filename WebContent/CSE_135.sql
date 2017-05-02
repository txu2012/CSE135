CREATE TABLE users(
    userID INTEGER PRIMARY KEY,
    personName TEXT UNIQUE,
    roles TEXT,
    age INTEGER,
    states TEXT
    );
    
CREATE TABLE categories(
    catID INTEGER PRIMARY KEY,
    catName TEXT UNIQUE,
    descrip TEXT,
    prodNum INTEGER
    );

CREATE TABLE products(
    prodID INTEGER PRIMARY KEY,
    prodName TEXT,
    SKU_Num TEXT UNIQUE,
    catgeory_name TEXT REFERENCES categories(catName) NOT NULL,
    price INTEGER,
    ownID TEXT REFERENCES users(personName) NOT NULL
    );
    
CREATE TABLE shoppingCart(
    shoppingID INTEGER PRIMARY KEY,
    shoppingUsers TEXT REFERENCES users(personName) NOT NULL,
    totalPrice INTEGER,
    ammount INTEGER,
    productItems TEXT REFERENCES products(SKU_Num) NOT NULL
    );