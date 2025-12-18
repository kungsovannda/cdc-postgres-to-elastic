import com.github.javafaker.Faker;
import domain.Product;
import repository.ProductRepository;

import java.util.Scanner;

public class Main
{
    public static void main(String[] args) throws InterruptedException {

        ProductRepository.createProductDb();
        System.out.print("[+] ENTER THE AMOUNT OF PRODUCTS: ");
        int amount = new Scanner(System.in).nextInt();

        var faker = Faker.instance();

        for (int i = 0; i < amount; i++) {
            Product product = new Product(
                 faker.commerce().productName(),
                    faker.book().title(),
                    Double.parseDouble(faker.commerce().price()),
                    faker.number().randomDigit(),
                    faker.commerce().department()
            );

            ProductRepository.insertProduct(product);

            System.out.println( "[*] " + (i+1) + ". PRODUCT INSERTED SUCCESSFULLY : " + product.getName());

            Thread.sleep(
                    3000
            );
        }


    }
}
