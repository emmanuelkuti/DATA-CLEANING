--- Create Database
CREATE DATABASE SQL_DATA_CLEANING;

--- Select SQL_CLEANING as default schema
USE SQL_DATA_CLEANING

--- Change Saledate data type to Date
ALTER TABLE NashvilleHousing
ALTER COLUMN SaleDate DATE;

--- Delete duplicate data
WITH RowNumCTE AS( 
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SaleDate,
				SalePrice,
				LegalReference,
				OwnerName
	ORDER BY 
				UniqueID) row_num
	FROM NashvilleHousing
	)
DELETE
FROM
	RowNumCTE
WHERE 
	row_num >1;

--- Populate null values for Property Address
UPDATE 
	nh
SET 
	PropertyAddress = ISNULL(nh.PropertyAddress,nh2.PropertyAddress)
FROM
	NashvilleHousing nh
JOIN 
	NashvilleHousing nh2
ON
	nh.ParcelID = nh2.ParcelID
AND
	nh.UniqueID <> nh2.UniqueID;

--- DelimiterSplit of PropertyAddress into Address and City
SELECT 
	SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) Address,
	SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))  City
FROM  
	NashvilleHousing
ORDER BY 
	1;

--- Update table
ALTER TABLE
	NashvilleHousing
ADD
	Split_PropertyAddress Nvarchar(255), --- add columns
	Split_PropertyCity Nvarchar(255);

UPDATE
	NashvilleHousing 
SET
	Split_PropertyAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1),
	Split_Propertycity = SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress));


--- DelimiterSplit of OwnerAddress into Address, City, State
SELECT 
    SUBSTRING(OwnerAddress, 1, CHARINDEX(',', OwnerAddress) - 1) AS Split_OwnerAddress,
    SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress) + 2, 
              CHARINDEX(',', OwnerAddress, CHARINDEX(',', OwnerAddress) + 1) - CHARINDEX(',', OwnerAddress) - 2) AS Split_OwnerCity,
    RIGHT(OwnerAddress, LEN(OwnerAddress) - CHARINDEX(',', OwnerAddress, CHARINDEX(',', OwnerAddress) + 1) - 1) AS Split_OwnerState
FROM 
    NashvilleHousing;

--- Update table
ALTER TABLE
	NashvilleHousing
ADD 
	Split_OwnerAddress Nvarchar(255),
	Split_OwnerCity Nvarchar(255),
	Split_OwnerState Nvarchar(255);

UPDATE NashvilleHousing
SET 
	Split_OwnerAddress = SUBSTRING(OwnerAddress, 1, CHARINDEX(',', OwnerAddress) - 1),
	Split_OwnerCity = SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress) + 2,
              CHARINDEX(',', OwnerAddress, CHARINDEX(',', OwnerAddress) + 1) - CHARINDEX(',', OwnerAddress) - 2),
	Split_OwnerState =  RIGHT(OwnerAddress, LEN(OwnerAddress) - CHARINDEX(',', OwnerAddress, CHARINDEX(',', OwnerAddress) + 1) - 1);

--- Changing the Y and N to Yes and No in SoldAsVacant column
SELECT 
    SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 1 THEN 'Yes'  
    WHEN SoldAsVacant = 0 THEN 'No'  
    ELSE 'Unknown'                    
    END 
FROM 
    NashvilleHousing; 

--- Updating table
ALTER TABLE	
	NashvilleHousing
ADD 
	SoldAsVacantStatus Nvarchar (255); --- add column

UPDATE 
	NashvilleHousing
SET 
SoldAsVacantStatus = CASE 
        WHEN SoldAsVacant = 1 THEN 'Yes'  
        WHEN SoldAsVacant = 0 THEN 'No'  
        ELSE 'Unknown'                    
    END;
	
---- Extract day month and year from Saledate
ALTER TABLE NashvilleHousing
ADD SaleYear INT, SaleMonth INT, SaleDay INT;

UPDATE NashvilleHousing
SET SaleYear = YEAR(SaleDate),
	SaleMonth = MONTH(SaleDate),
	SaleDay = DAY(SaleDate);

--- Check for null count
 SELECT COUNT(*) AS NullCount, 'OwnerName' AS ColumnName
FROM NashvilleHousing
WHERE OwnerName IS NULL
UNION ALL
SELECT COUNT(*), 'OwnerAddress' FROM NashvilleHousing WHERE OwnerAddress IS NULL
UNION ALL
SELECT COUNT(*), 'Acreage' FROM NashvilleHousing WHERE Acreage IS NULL

--- Check Outliers
SELECT *
FROM NashvilleHousing
WHERE SalePrice > 10000000

--- Delete irrelevant columns

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress,SoldAsVacant, TaxDistrict, Saledate;












