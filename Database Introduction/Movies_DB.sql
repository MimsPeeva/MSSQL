CREATE DATABASE Movies

CREATE TABLE Directors
(
Id INT PRIMARY KEY  IDENTITY,
DirectorName VARCHAR(200)  NOT NULL,
Notes VARCHAR(MAX)
)

INSERT INTO Directors (DirectorName)
VALUES
('Kevin'),
('Tomas'),
('Ema'),
('Ben'),
('Didi')

CREATE TABLE Genres
(
Id INT PRIMARY KEY IDENTITY,
GenreName VARCHAR(200)  NOT NULL,
Notes VARCHAR(MAX)
)
INSERT INTO Genres(GenreName)
VALUES
('Horror'),
('Comedy'),
('Action'),
('Romantic'),
('Fantasy')

CREATE TABLE Categories
(
Id INT PRIMARY KEY  IDENTITY,
CategoryName VARCHAR(200)  NOT NULL,
Notes VARCHAR(MAX)
)
INSERT INTO Categories(CategoryName)
VALUES
('One'),
('Two'),
('Three'),
('Four'),
('Five')
CREATE TABLE Movies
(
Id INT PRIMARY KEY  IDENTITY,
Title VARCHAR(200)  NOT NULL,
DirectorId INT FOREIGN KEY REFERENCES [DIRECTORS](Id) NOT NULL,
CopyrightYear INT NOT NULL,
Length TIME NOT NULL,
GenreId INT FOREIGN KEY REFERENCES [Genres](Id)  NOT NULL,
CategoryId INT FOREIGN KEY REFERENCES [Categories](Id)  NOT NULL,
Rating INT,
Notes VARCHAR(MAX)
)
INSERT INTO Movies(Title,DirectorId,CopyrightYear,Length,GenreId,CategoryId,Rating)
VALUES('First movie',3,2012,'02:00:00',1,1,5),
('Second movie',5,1999,'01:40:00',4,2,3),
('Third movie',1,1976,'01:07:20',2,5,4),
('Fourth movie',2,2002,'00:55:00',3,3,1),
('Fifth movie',4,1987,'01:32:00',5,4,2)

SELECT*FROM Movies