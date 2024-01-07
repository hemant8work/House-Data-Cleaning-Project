select * from houses

-- CONVERTING IN CORRECT FORMAT

ALTER TABLE houses
ALTER COLUMN SaleDate Date

"""
Directly changed the columln data type instead of creating new & then deleting old one.
"""

-- POPULATING PROPERTY ADDRESS

select * from houses
where [PropertyAddress] is null

select * from houses
order by parcelid

SELECT ha.Parcelid, ha.PropertyAddress,hb.Parcelid, hb.PropertyAddress
FROM houses ha
JOIN houses hb
ON ha.ParcelID = hb.ParcelID 
AND ha.[UniqueID]<>hb.[UniqueID]
where ha.PropertyAddress is null

UPDATE ha
SET propertyaddress = ISNULL(ha.PropertyAddress,hb.PropertyAddress)
FROM houses as ha
JOIN houses as hb
ON ha.ParcelID = hb.ParcelID 
AND ha.[UniqueID]<>hb.[UniqueID]
where ha.PropertyAddress is null


-- SEPERATING ADDRESS, CITY, STATE

select PropertyAddress from houses

SELECT PropertyAddress ,SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1), 
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
FROM houses

ALTER TABLE houses
 Add_HouseNo nvarchar(255), Add_City varchar(255), Add_State varchar(255)

UPDATE houses
SET Add_HouseNo = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

UPDATE houses
SET Add_City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT PropertyAddress, Add_HouseNo, Add_City FROM houses


-- Now with Parsename & replace function for Owner Address

SELECT OwnerAddress FROM houses
WHERE OwnerAddress IS NOT NULL

SELECT OwnerAddress, PARSENAME(REPLACE(OwnerAddress,',','.'),1), PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
FROM houses
WHERE OwnerAddress IS NOT NULL


SELECT OwnerAddress, PARSENAME(REPLACE(OwnerAddress,',','.'),3), PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM houses
WHERE OwnerAddress IS NOT NULL

ALTER TABLE houses
ADD OwnAdd_HouseNo varchar(255), OwnAdd_City varchar(255), OwnAdd_State varchar(255)

UPDATE houses
SET OwnAdd_HouseNo = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

SELECT OwnerAddress, OwnAdd_HouseNo, OwnAdd_City, OwnAdd_State FROM houses
WHERE OwnerAddress IS NOT NULL

UPDATE houses
SET OwnAdd_City = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

UPDATE houses
SET OwnAdd_State = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT * FROM houses

--Change Yes to Y, No to N

SELECT SoldAsVacant FROM houses

UPDATE houses
SET SoldAsVacant = SUBSTRING(SoldAsVacant,1,1)

-- Need to Change to Yes and NO

SELECT SoldAsVacant FROM houses

UPDATE houses
SET SoldAsVacant = 'Yes'
WHERE SoldAsVacant = 'Y'

UPDATE houses
SET SoldAsVacant = 'No'
WHERE SoldAsVacant = 'N'


SELECT SoldAsVacant FROM houses
WHERE SoldAsVacant NOT IN ('YES','NO')


-- REMOVING DUPLICATES

SELECT * FROM houses

WITH cte_rown AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY
      [ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
	  ORDER BY UniqueID) AS Rown FROM houses
)
SELECT * FROM cte_rown 
WHERE Rown > 1


WITH cte_rown AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY
      [ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
	  ORDER BY UniqueID) AS Rown FROM houses
)
DELETE 
FROM cte_rown
WHERE Rown>1


--REMOVING UNNECESSARY COLUMNS

SELECT * FROM houses

ALTER TABLE houses
DROP COLUMN PropertyAddress, OwnerAddress



"""
DONE :)
"""