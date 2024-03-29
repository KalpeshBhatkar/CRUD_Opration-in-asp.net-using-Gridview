
/****** Object:  StoredProcedure [dbo].[spInsertUpdateCustomer]    Script Date: 17/11/2019 4:32:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[spInsertUpdateCustomer]
@CustomerID int
,@Name varchar(250)
,@MobileNo varchar(15)
,@Gender varchar(15)
,@EmailID varchar(250)
,@UserID int
as
begin
if not exists(Select CustomerID from [dbo].[CustomerMaster] where CustomerID = @CustomerID)
begin
insert [dbo].[CustomerMaster] (Name
,MobileNo
,Gender
,EmailID
,CreatedID
,CreatedDate
,Deleted
)
values (
@Name
,@MobileNo
,@Gender
,@EmailID
,@UserID
,GETDATE()
,0)

Select @@IDENTITY as CustomerID
end
else
begin
update [dbo].[CustomerMaster] set 
Name = @Name
,MobileNo = @MobileNo
,Gender = @Gender
,EmailID = @EmailID
,ModifiedID = @UserID
,ModifiedDate = GETDATE()
where CustomerID = @CustomerID

select @CustomerID as CustomerID
end
end

/****** Object:  StoredProcedure [dbo].[spDeleteCustomer]    Script Date: 17/11/2019 4:32:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[spDeleteCustomer]
@CustomerID int
,@UserID int
as
begin
update [dbo].[CustomerMaster] set DeletedID = @UserID
,DeletedDate = GETDATE()
,Deleted = 1
where CustomerID = @CustomerID
end

/****** Object:  StoredProcedure [dbo].[spSelectCustomer]    Script Date: 17/11/2019 4:32:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[spSelectCustomer]
@CustomerID int
as
begin
if exists(Select CustomerID from [dbo].[CustomerMaster] where Deleted = 0)
begin
Select CustomerID,Name,MobileNo,Gender,EmailID from [dbo].[CustomerMaster]
where Deleted = 0 and (CustomerID = @CustomerID or 0 = @CustomerID)
end
else
begin
Select 0 as CustomerID,'' as Name,'' as MobileNo,'' as Gender,'' as EmailID
end
end