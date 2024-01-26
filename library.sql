create database library;
use library;
create table tbl_publisher
(publisher_PublisherName varchar(255) primary key,
publisher_PublisherAddress varchar(255),
publisher_PublisherPhone varchar(255));

create table tbl_borrower
(borrower_CardNo tinyint primary key auto_increment,
borrowe_BorrowerName varchar(255),
borrower_BorrowerAddress varchar(255),
borrower_BorrowerPhone varchar(255));

create table tbl_library_branch
(library_branch_BranchID int primary key auto_increment,
library_branch_BranchName varchar(255), 
library_BranchAddress varchar(255));

create table tbl_book
(book_BookID tinyint primary key auto_increment,
book_Title varchar(255),
book_PublisherName varchar(255),
foreign key(book_PublisherName) references tbl_publisher(publisher_PublisherName) on delete cascade);

create table tbl_book_authors
(book_authors_AuthorID int primary key auto_increment,
book_authors_BookID tinyint, foreign key (book_authors_BookID) references tbl_book(book_BookID) on delete cascade,
book_authors_AuthorName varchar(255));

create table tbl_book_copies
(book_copies_CopiesID tinyint primary key auto_increment,
book_copies_BookID tinyint, foreign key(book_copies_BookID) references tbl_book(book_BookID),
book_copies_BranchID int, foreign key (book_copies_BranchID) references tbl_library_branch(library_branch_BranchID),
book_copies_No_Of_Copies tinyint);

create table tbl_book_loans
(book_loans_LoansID tinyint primary key auto_increment,
book_loans_BookID tinyint,foreign key (book_loans_BookID) references tbl_book(book_BookID) on delete cascade,
book_loans_BranchID int, foreign key(book_loans_BranchID) references tbl_library_branch(library_branch_BranchID) on delete cascade,
book_loans_CardNo tinyint, foreign key(book_loans_CardNo) references tbl_borrower(borrower_CardNo) on delete cascade,
book_loans_DateOut date , book_loans_DueDate date);






-- questions
-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select tbook.book_title, tb.library_branch_BranchName,tc.book_copies_No_Of_copies as count_of_copies from tbl_book_copies as tc 
join tbl_library_branch as tb on tc.book_copies_branchID = tb.library_branch_BranchID join tbl_book as tbook on tbook.book_BookID = tc.book_copies_BookID 
where book_Title = 'The Lost Tribe' and library_branch_BranchName='Sharpstown';

-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select tbook.book_title, tb.library_branch_BranchName,tc.book_copies_No_Of_copies as count_of_copies from tbl_book_copies as tc 
join tbl_library_branch as tb on tc.book_copies_branchID = tb.library_branch_BranchID join tbl_book as tbook on tbook.book_BookID = tc.book_copies_BookID 
where book_Title = 'The Lost Tribe';


-- 3.Retrieve the names of all borrowers who do not have any books checked out 
select tb.borrower_BorrowerName from tbl_borrower as tb 
where tb.borrower_CardNo not in (select distinct(tl.book_loans_CardNo) from tbl_book_loans as tl);


-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
select tbook.book_Title,tb.borrower_BorrowerName,tb.borrower_BorrowerAddress from tbl_borrower as tb 
join tbl_book_loans as tl on tb.borrower_CardNo = tl.book_loans_CardNo 
join tbl_library_branch as tlb on tlb.library_branch_BranchID = tl.book_loans_BranchID 
join tbl_book as tbook on tbook.book_BookID = tl.book_loans_BookID
where tlb.library_branch_BranchName = 'Sharpstown' and tl.book_loans_DueDate = '2018-03-02';



-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select tb.library_branch_BranchName,count(tl.book_loans_BookID) as total_loaned_books from tbl_book_loans as tl 
join tbl_library_branch as tb on tl.book_loans_BranchID = tb.library_branch_BranchID group by tb.library_branch_BranchName;


-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select tb.borrower_BorrowerName,tb.borrower_BorrowerAddress,count(tl.book_loans_CardNo) as books_count from  tbl_borrower as tb 
join tbl_book_loans as tl on tb.borrower_CardNo = tl.book_loans_CardNo group by tb.borrower_BorrowerName,tl.book_loans_CardNo having books_count>5;


-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select ta.book_authors_AuthorName,tb.book_title,tc.book_copies_No_of_copies as No_of_copies from tbl_book_authors as ta 
join tbl_book as tb on tb.book_BookID = ta.book_authors_BookID
join tbl_book_copies as tc on tc.book_copies_bookid = tb.book_BookID
join tbl_library_branch as tl on tc.book_copies_BranchID = tl.library_Branch_BranchID
where ta.book_authors_AuthorName = 'stephen king' and tl.library_branch_BranchName = 'Central';