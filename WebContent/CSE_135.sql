CREATE TABLE users(
    userID BIGSERIAL NOT NULL PRIMARY KEY,
    personName TEXT UNIQUE,
    roles TEXT,
    age INTEGER,
    states TEXT
    );
    
CREATE TABLE categories(
    catID BIGSERIAL NOT NULL PRIMARY KEY,
    catName TEXT UNIQUE,
    descrip TEXT,
    prodNum INTEGER
    );

CREATE TABLE products(
    prodID BIGSERIAL NOT NULL PRIMARY KEY,
    prodName TEXT,
    SKU_Num TEXT UNIQUE,
    category_name TEXT REFERENCES categories(catName),
    price REAL,
    ownID TEXT REFERENCES users(personName)
    );
    
CREATE TABLE shoppingCart(
    shoppingID BIGSERIAL NOT NULL PRIMARY KEY,
    shoppingUsers TEXT REFERENCES users(personName) NOT NULL,
    totalPrice REAL,
    amount INTEGER,
    productItems TEXT REFERENCES products(SKU_Num)
    );
    
CREATE TABLE purchased(
    purchasedID BIGSERIAL NOT NULL PRIMARY KEY,
    purchasedUser TEXT REFERENCES users(personName) NOT NULL,
    purchasedDate TEXT,
    purchasedItem TEXT REFERENCES products(SKU_Num),
    purchasedAmount INTEGER,
	purchasedName TEXT,
	purchasedPrice REAL
    );