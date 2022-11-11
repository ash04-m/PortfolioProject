-- Data Cleaning for portfolio_project

select *
from portfolio_project.dbo.NashvilleHousing

-- Standard Date Transformation

select SaleDate
from portfolio_project.dbo.NashvilleHousing

Alter table portfolio_project.dbo.NashvilleHousing
Alter column SaleDate date

--Populate Property Address

select*
from portfolio_project.dbo.NashvilleHousing
where PropertyAddress is null

select a.parcelid, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
from portfolio_project.dbo.NashvilleHousing a
join portfolio_project.dbo.NashvilleHousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

update a
set a.propertyaddress= ISNULL(a.propertyaddress, b.PropertyAddress)
select a.parcelid, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
from portfolio_project.dbo.NashvilleHousing a
join portfolio_project.dbo.NashvilleHousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

--Breaking address into individual column

SELECT PropertyAddress
FROM portfolio_project.dbo.NashvilleHousing

SELECT PARSENAME(REPLACE(PropertyAddress,',','.'),2),PARSENAME(REPLACE(PropertyAddress,',','.'),1)
FROM portfolio_project.dbo.NashvilleHousing

ALTER TABLE portfolio_project.dbo.NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

ALTER TABLE portfolio_project.dbo.NashvilleHousing
ADD PropertySplitCity nvarchar(255)

UPDATE portfolio_project.dbo.NashvilleHousing
SET PropertySplitAddress= PARSENAME(REPLACE(PropertyAddress,',','.'),2)

UPDATE portfolio_project.dbo.NashvilleHousing
SET PropertySplitCity= PARSENAME(REPLACE(PropertyAddress,',','.'),1)

select OwnerAddress
from portfolio_project.dbo.NashvilleHousing

select PARSENAME(REPLACE( OwnerAddress, ',','.'),3),
PARSENAME(REPLACE( OwnerAddress, ',','.'),2) ,
PARSENAME(REPLACE( OwnerAddress, ',','.'),1) 
from portfolio_project.dbo.NashvilleHousing


ALTER TABLE portfolio_project.dbo.NashvilleHousing
 ADD OwnerSplitAddress nvarchar(255)

ALTER TABLE portfolio_project.dbo.NashvilleHousing
 ADD OwnerSplitCity nvarchar(255)

 ALTER TABLE portfolio_project.dbo.NashvilleHousing
 ADD OwnerSplitState nvarchar(255)

 UPDATE  portfolio_project.dbo.NashvilleHousing
 SET OwnerSplitAddress= PARSENAME(REPLACE( OwnerAddress, ',','.'),3)

 UPDATE  portfolio_project.dbo.NashvilleHousing
 SET OwnerSplitCity= PARSENAME(REPLACE( OwnerAddress, ',','.'),2)
 
 UPDATE  portfolio_project.dbo.NashvilleHousing
 SET OwnerSplitState= PARSENAME(REPLACE( OwnerAddress, ',','.'),1)

 ALTER TABLE portfolio_project.dbo.NashvilleHousing
 DROP COLUMN OwnerCity , OwnerState

 SELECT *
 FROM portfolio_project.dbo.NashvilleHousing

 --Change Y and N to Yes , No in 'SoldAsVacant' column

SELECT DISTINCT(Soldasvacant),COUNT(SoldasVacant)
FROM portfolio_project.dbo.NashvilleHousing
GROUP BY SoldasVacant

SELECT Soldasvacant,
   CASE
   WHEN Soldasvacant='Y' then 'YES'
   WHEN Soldasvacant= 'N' then 'NO'
   ELSE Soldasvacant
   END
FROM portfolio_project.dbo.NashvilleHousing

UPDATE portfolio_project.dbo.NashvilleHousing
SET Soldasvacant =  CASE
                    WHEN Soldasvacant='Y' then 'YES'
                    WHEN Soldasvacant= 'N' then 'NO'
                    ELSE Soldasvacant
                    END

SELECT SoldAsVacant
FROM portfolio_project.dbo.NashvilleHousing

-- Remove Duplicates

SELECT *
FROM portfolio_project.dbo.NashvilleHousing

WITH my_cte AS (
 SELECT    ROW_NUMBER() OVER(
             PARTITION BY
               UniqueID,
			   ParcelID,
			   PropertyAddress,
			   SaleDate,
			   LegalReference
			   order by 
			   Uniqueid
			   ) row_num, * 
FROM portfolio_project.dbo.NashvilleHousing)

SELECT *
from my_cte
where row_num >1
order by PropertyAddress

WITH my_cte AS (
 SELECT    ROW_NUMBER() OVER(
             PARTITION BY
               UniqueID,
			   ParcelID,
			   PropertyAddress,
			   SaleDate,
			   LegalReference
			   order by 
			   Uniqueid
			   ) row_num, * 
FROM portfolio_project.dbo.NashvilleHousing)
DELETE
from my_cte
where row_num >1


-- Remove unused columns

SELECT *
FROM portfolio_project.dbo.NashvilleHousing

ALTER TABLE portfolio_project.dbo.NashvilleHousing
DROP COLUMN OwnerAddress,PropertyAddress, TaxDistrict,SaleDate


