
CREATE TABLE anothertable (
   id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
   name TEXT NOT NULL,
   age INT NOT NULL,
   address CHAR(50)
);
