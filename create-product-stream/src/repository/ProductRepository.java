package repository;

import config.DBConfig;
import domain.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

public class ProductRepository {

    public static void createProductDb(){
        String sql = """
                CREATE TABLE IF NOT EXISTS products (
                    id SERIAL PRIMARY KEY,
                    name VARCHAR,
                    description TEXT,
                    price DECIMAL,
                    quantity INTEGER,
                    category VARCHAR
                );
                """;

        try(Connection conn = DBConfig.getConnection()) {
            Statement stmt = conn.createStatement();
            stmt.execute(sql);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static Product insertProduct(Product product){
        String sql = """
                    INSERT INTO products (name, description, quantity, price, category)
                    VALUES (?, ?, ?, ?, ?);
                """;
        try(Connection conn = DBConfig.getConnection()) {
            PreparedStatement stmt = conn.prepareCall(sql);
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setInt(3, product.getQuantity());
            stmt.setDouble(4, product.getPrice());
            stmt.setString(5, product.getCategory());
            return stmt.executeUpdate() == 1 ? product : null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
