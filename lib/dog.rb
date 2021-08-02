class Dog

    attr_accessor :id, :name, :breed
  
    def initialize(id: nil, name:, breed:)
      @id, @name, @breed = id, name, breed
    end
  
    def self.create_table
      sql = <<-SQL
        CREATE TABLE dogs (
          id INTEGER PRIMARY KEY,
          name TEXT,
          breed TEXT
        )
      SQL
      DB[:conn].execute(sql)
    end
  
    def self.drop_table
      sql = <<-SQL
        DROP TABLE dogs
      SQL
      DB[:conn].execute(sql)
    end
  
    def save
      sql = <<-SQL
        INSERT INTO dogs (
          name, breed
        ) VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute(
        "SELECT last_insert_rowid() FROM dogs"
      )[0][0]
      self
    end
  
    def self.create(id: nil, name:, breed:)
      Dog.new(id: id, name: name, breed: breed).save
    end
  
    def self.new_from_db(rw)
      self.new(name: rw[1], breed: rw[2], id: rw[0])
    end
  
    def self.all
      sql = <<-SQL
        SELECT * FROM dogs
      SQL
      DB[:conn].execute(sql).map do |rw|
        self.new_from_db(rw)
      end
    end
  
    def self.find_by_name(name)
      sql = <<-SQL
        SELECT * FROM dogs WHERE name = ?
      SQL
      self.new_from_db( 
        DB[:conn].execute(sql, name)[0]
      )
    end
  
    def self.find(id)
      sql = <<-SQL
        SELECT * FROM dogs WHERE id = ?
      SQL
      self.new_from_db( 
        DB[:conn].execute(sql, id)[0]
      )
    end
  end