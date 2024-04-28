-- Testing the Table
SELECT
	* 
FROM
	[dbo].[NashvilleHousing] 

--Changing the Date
SELECT
	--Saledate 
	SaleDateConv
FROM
	[dbo].[NashvilleHousing] 

UPDATE [dbo].[NashvilleHousing] 
SET SaleDateConv = CONVERT ( DATE, Saledate )
	
--Didnt work so we will try to add a table
Alter TABLE NashvilleHousing
ADD SaleDateConv DATE

--Change the Propety address null values since it is displayed incorrectly in some parts
UPDATE a 
SET a.PropertyAddress = b.PropertyAddress 
FROM
	NashvilleHousing a
	JOIN NashvilleHousing b ON a.ParcelID = b.ParcelID 
WHERE
	a.PropertyAddress IS NULL 
	AND b.PropertyAddress IS NOT NULL;
	
-- Breaking down Property  address for better sorting address + city (Can also use PARSNAME but u need to change , to a .)
SELECT
Propertyaddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)  as address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, 100)  as city
from [dbo].[NashvilleHousing] 

--Adding new tables and updating them
Alter TABLE NashvilleHousing
ADD address Nvarchar(255)
Alter TABLE NashvilleHousing
ADD city Nvarchar(255)

UPDATE NashvilleHousing
SET address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) ,
city = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, 100)

-- Testing 
SELECT
*
from [dbo].[NashvilleHousing] 

-- Updateing the Y & N to Yes and No in the Soldasvacant  (Can also use CASE WHEN)

UPDATE [dbo].[NashvilleHousing] 
SET Soldasvacant = 'No'
WHERE  Soldasvacant = 'N'

UPDATE [dbo].[NashvilleHousing] 
SET Soldasvacant = 'Yes'
WHERE  Soldasvacant = 'Y'

-- Deleting Dublicate Data will use CTE
WITH dubCTE AS (

SELECT *,
ROW_NUMBER() OVER (Partition by ParcelID, address, city, SalePrice ORDER BY uniqueID) dub

FROM [dbo].[NashvilleHousing] 
) 
DELETE

FROM dubCTE

where dub = 2





