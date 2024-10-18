import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.WebElement;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class SeleniumTest {

    private WebDriver driver;

    @Before
    public void setUp() {
        // Set the path to the chromedriver executable
        System.setProperty("webdriver.chrome.driver", "path/to/chromedriver");
        driver = new ChromeDriver();
    }

    @Test
    public void testHomepage() {
        // Navigate to your web application
        driver.get("http://localhost"); // Adjust to your application's URL

        // Example test: Check the title of the page
        String title = driver.getTitle();
        assertEquals("Expected Page Title", title);

        // Example test: Check for an element
        WebElement element = driver.findElement(By.id("exampleElementId")); // Replace with an actual ID
        assertNotNull("Element should be present", element);
    }

    @After
    public void tearDown() {
        // Close the browser
        if (driver != null) {
            driver.quit();
        }
    }
}
