module Books
  class Cheapests < Rectify::Query
    def query
      Book
        .joins(<<-SQL)
          INNER JOIN (
            SELECT MIN(price) as min_price, publisher_id
            FROM books
            GROUP BY publisher_id
          ) cheapests_books
          ON books.publisher_id = cheapests_books.publisher_id
          AND books.price = cheapests_books.min_price
        SQL
    end
  end
end
