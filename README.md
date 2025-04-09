# SQL-DATA-CLEANING
This project focuses on cleaning and transforming the Nashville Housing dataset to make it more suitable for data analysis. It involves applying various SQL techniques to address common issues such as duplicates, null values, inconsistent formats, and outliers. By performing these data cleaning operations, the dataset becomes more reliable and structured for further exploration and analysis.
Database Setup: The project starts by creating a clean, new database called SQL_DATA_CLEANING, keeping the original dataset safe while we work on improving it.
Data Transformation: The SaleDate column is adjusted to ensure it's stored as a proper DATE data type.
Duplicate rows are removed using a smart ROW_NUMBER() technique, so only unique records are kept.
Missing PropertyAddress values are filled in by referencing other rows with the same ParcelID, ensuring no data gaps are left in PropertyAddress
Splitting Combined Data: The PropertyAddress column is split into two new columns: one for the street address and another for the city, making it easier to work with.
The same approach is applied to the OwnerAddress, splitting it into three separate columns for address, city, and state.
Improving Categorical Data: The SoldAsVacant column, which was a bit datatype (1 or 0), is transformed into something much clearer: ‘Yes’ for 1 and ‘No’ for 0. This makes it easier to interpret the data at a glance.
Extracting Date Components: Added new columns to break down the SaleDate into separate parts: SaleYear, SaleMonth, and SaleDay, which is super helpful for time-based analysis.
Identifying Outliers: The dataset is checked for unusually high sale prices (over $10 million), and those outliers are flagged for review.
Removing Unnecessary Columns: Once the key data is processed, irrelevant columns like PropertyAddress, OwnerAddress, and SoldAsVacant are dropped to keep things clean and streamlined.
These steps ensure the dataset is clean, consistent, and ready for further analysis and insights.
