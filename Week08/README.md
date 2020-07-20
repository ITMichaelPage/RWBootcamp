## **Packaging Seed Data Options**

As a precursor, storing any type of seed data inside the app bundle, prevents direct modification of the seed data. Storing it in the user’s documents directory would allow for write access.

### **Consider XML**

Instead of storing the seed data as JSON (JavaScript Object Notation) we could store it as XML (Extensible Markup Language) in a property list file. Although Apple makes use of property list files, JSON is the primary method when communicating with online APIs.

### **Pre-filled SQLite Database**

Populate the database with a utility app that either uses Core Data APIs or updates in the database directly. Then include the database with the app bundle. The first time the app loads, it will copy the database into the user’s documents directory and use the copy going forward.

### **Which makes the most sense?**

With the tiny amount of sandwich data, a JSON seed data is ideal, a larger amount of sandwich data (e.g. 100+ sandwiches) would warrant a pre-filled SQLite database.