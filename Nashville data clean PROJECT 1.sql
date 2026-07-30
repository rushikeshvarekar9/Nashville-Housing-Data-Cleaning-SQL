-- 1. CREATE STAGING TABLE TO CLEAN DATA

SELECT * FROM housing_nashville.`nashville housing`;

CREATE TABLE staging_nashville
LIKE `nashville housing`;

SELECT * FROM staging_nashville;

INSERT INTO staging_nashville
SELECT * FROM housing_nashville.`nashville housing`;

SELECT * FROM staging_nashville;

###########################################################################################################################################

-- 2. REMOVE DUPLICATE

SELECT * FROM staging_nashville;

SELECT *,
ROW_NUMBER() OVER(
			PARTITION BY parcelID,propertyaddress,saledate,saleprice,legalreference ORDER BY uniqueID) row_num
FROM staging_nashville;

WITH duplicate_CTE AS
(SELECT *,
ROW_NUMBER() OVER(
			PARTITION BY parcelID,propertyaddress,saledate,saleprice,legalreference ORDER BY uniqueID) row_num
FROM staging_nashville
)
SELECT *
FROM duplicate_CTE
WHERE row_num > 1;

CREATE TABLE `staging_nashville2` (
  `UniqueID` int DEFAULT NULL,
  `ParcelID` text,
  `LandUse` text,
  `PropertyAddress` text,
  `SaleDate` text,
  `SalePrice` int DEFAULT NULL,
  `LegalReference` text,
  `SoldAsVacant` text,
  `OwnerName` text,
  `OwnerAddress` text,
  `Acreage` double DEFAULT NULL,
  `TaxDistrict` text,
  `LandValue` int DEFAULT NULL,
  `BuildingValue` int DEFAULT NULL,
  `TotalValue` int DEFAULT NULL,
  `YearBuilt` int DEFAULT NULL,
  `Bedrooms` int DEFAULT NULL,
  `FullBath` int DEFAULT NULL,
  `HalfBath` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM staging_nashville2;

INSERT INTO staging_nashville2
SELECT *,
ROW_NUMBER() OVER(
			PARTITION BY parcelID,propertyaddress,saledate,saleprice,legalreference ORDER BY uniqueID) row_num
FROM staging_nashville;

SELECT * FROM staging_nashville2;

SELECT * 
FROM staging_nashville2
WHERE row_num > 1 ;

SET SQL_SAFE_UPDATES = 0 ;

DELETE
FROM staging_nashville2
WHERE row_num > 1;
###############################################################################################################################

-- 3. CHANGE THE DATE STRING TYPE

SELECT * FROM staging_nashville2;

SELECT saledate,str_to_date(saledate,'%M %e,%Y') newdate
FROM staging_nashville2
GROUP BY SaleDate;

UPDATE staging_nashville2
SET saledate = str_to_date(saledate,'%M %e,%Y') ;

SELECT * FROM staging_nashville2; -- date string type change
############################################################################################################################
-- 4. POPUPATE PROPERTY ADDRESS COLUMN 

SELECT * FROM staging_nashville2;

SELECT PropertyAddress,COUNT(PropertyAddress)
FROM staging_nashville2
WHERE PropertyAddress = null
OR PropertyAddress = ''
GROUP BY PropertyAddress;               -- 18 values needs to be populated

SELECT a.ParcelID,
       a.PropertyAddress,
	   b.PropertyAddress,
COALESCE(NULLIF(a.propertyaddress,''),b.propertyaddress) FIXEDADDRESS
FROM staging_nashville2 a
JOIN staging_nashville2 b
	ON a.ParcelID  = b.ParcelID 
WHERE (a.PropertyAddress IS NULL OR a.PropertyAddress = '')
AND b.PropertyAddress IS NOT NULL;

UPDATE staging_nashville2
SET PropertyAddress = null
WHERE propertyaddress = '';

UPDATE staging_nashville2 a 
JOIN staging_nashville2 b
	ON a.ParcelID = b.ParcelID
SET a.PropertyAddress = b.PropertyAddress
WHERE a.PropertyAddress IS NULL 
AND b.PropertyAddress IS NOT NULL; -- populated property address column
################################################################################################################################################

-- 5. SEPRATE PROPERTY ADDRESS COLUMN 

SELECT * FROM staging_nashville2;

SELECT propertyaddress,
      SUBSTRING_INDEX(propertyaddress,',',1) address,
      SUBSTRING_INDEX(propertyaddress,',',-1) address
FROM staging_nashville2;

ALTER TABLE staging_nashville2
ADD PropertyCity VARCHAR(255) AFTER propertyaddress,
ADD PropertyState VARCHAR(255) AFTER PropertyCity;

UPDATE staging_nashville2
SET propertyCity = SUBSTRING_INDEX(propertyaddress,',',1),
	propertystate = SUBSTRING_INDEX(propertyaddress,',',-1);

SELECT * FROM staging_nashville2; -- Seprated property address
######################################################################################################################################

-- 7. SEPERATE OWNER ADDRESS

SELECT * FROM staging_nashville2;

SELECT owneraddress,
	SUBSTRING_INDEX(owneraddress,',',1) street,
    SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress,',',2),',',-1) city,
    SUBSTRING_INDEX(owneraddress,',',-1) state
FROM staging_nashville2;

ALTER TABLE staging_nashville2
ADD OwnerStreet VARCHAR(255) AFTER owneraddress,
ADD OwnerCity VARCHAR(255) AFTER OwnerStreet,
ADD OwnerState VARCHAR(255) AFTER OwnerCity;

UPDATE  staging_nashville2
SET OwnerStreet = SUBSTRING_INDEX(owneraddress,',',1),
    OwnerCity  = SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress,',',2),',',-1),
    OwnerState = SUBSTRING_INDEX(owneraddress,',',-1);

SELECT * FROM staging_nashville2; -- seprated owner address
######################################################################################################################################

-- 8.CHANGE Y & N TO YES AND NO RESPECTIVELY IN sold as vacant table

SELECT * FROM staging_nashville2;

SELECT soldasvacant,COUNT(soldasvacant)
FROM staging_nashville2
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT DISTINCT soldasvacant,
CASE 
	WHEN soldasvacant = 'Y' THEN 'Yes' 
    WHEN soldasvacant = 'N' THEN 'No'
    ELSE soldasvacant
END YES_NO
FROM staging_nashville2;

UPDATE staging_nashville2
SET soldasvacant = 
CASE 
	WHEN soldasvacant = 'Y' THEN 'Yes' 
    WHEN soldasvacant = 'N' THEN 'No'
    ELSE soldasvacant
END ;

SELECT * FROM staging_nashville2; -- changed
####################################################################################################################################################

-- 9. REMOVE UNECESSARY COLUMNS

SELECT * FROM staging_nashville2;

ALTER TABLE staging_nashville2
DROP COLUMN PropertyAddress,
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN row_num;

SELECT * FROM staging_nashville2;

##########-- DATA CLEANED --########## 

























































































































































































































































































