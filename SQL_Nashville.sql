select * 
from dbo.NashvilleHousing;

--standardise date format
select saledate 
from NashvilleHousing;

select Saledate, Convert(date, saledate)
from NashvilleHousing; 

alter table NashvilleHousing 
add SaleConvertedDate date;

select * from NashvilleHousing;

update NashvilleHousing 
set SaleConvertedDate = Convert(date,saledate);

select SaleConvertedDate 
from NashvilleHousing;
------------------------------------------------------------------------------------------

select * from dbo.[NashvilleHousing ];


select  a.PropertyAddress,b.PropertyAddress
from dbo.[NashvilleHousing ] a
join dbo.[NashvilleHousing ] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

update a
set PropertyAddress = ISNULL( a.PropertyAddress,b.PropertyAddress)
from dbo.[NashvilleHousing ] a
join dbo.[NashvilleHousing ] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

Select * from NashvilleHousing 
where PropertyAddress is NULL;

-------------------------------------------------------------

select PropertyAddress 
from  NashvilleHousing;

select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City
from NashvilleHousing;

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing 
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1);

select * from [NashvilleHousing ];

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing 
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress));

select * from NashvilleHousing; 

select PARSENAME(replace(OwnerAddress,',','.'),1)
from NashvilleHousing;

select PARSENAME(replace(OwnerAddress,',','.'),2) from [NashvilleHousing ];

select PARSENAME(replace(OwnerAddress,',','.'),3) from [NashvilleHousing ];

alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)

alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)

alter table NAshvilleHousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing 
set OwnerSplitstate = PARSENAME(replace(OwnerAddress,',','.'),1)

select * from [NashvilleHousing ]; 
------------------------------------------------------------------
select distinct(SoldAsVacant), count(SoldAsVacant) from 
NashvilleHousing
group by SoldAsVacant
order by 2;

select SoldAsVacant, 
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 ELSE SoldAsVacant 
	 END
from NashvilleHousing; 

Update [NashvilleHousing ] 
set SoldAsVacant  = case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 ELSE SoldAsVacant 
	 END

select * from NashvilleHousing; 

------------------------------------------------------------------------------------

--Remove Duplicates

 with NashvilleHousingCTE as
 (select * , ROW_NUMBER() Over 
  (Partition by ParcelID ,PropertyAddress, SaleDate, SalePrice, LegalReference
  Order by UniqueID) as DuplicateCount 
  from [NashvilleHousing ])

  Select * from NashvilleHousingCTE
  where DuplicateCount > 1
  order by PropertyAddress;


   with NashvilleHousingCTE as
 (select * , ROW_NUMBER() Over 
  (Partition by ParcelID ,PropertyAddress, SaleDate, SalePrice, LegalReference
  Order by UniqueID) as DuplicateCount 
  from [NashvilleHousing ])

  delete from NashvilleHousingCTE
  where Duplicatecount > 1;

  select * from [NashvilleHousing ];

  -----------------------------------------------------------
  --Delete unused columns 

  select * from [NashvilleHousing ];

  alter table NashvilleHousing
  drop column PropertyAddress, saleDate, OwnerAddress,TaXDistrict;
