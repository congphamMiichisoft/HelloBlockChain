pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Library is Ownable {
    string internal _name = "An Awesome Library";

    /**
     * Return library name
     */

    Book[] internal bookstore;
    mapping(uint256 => address) internal ledger;

    /**
    Event
     */
    event Borrow(address borrower, uint256 _bookId);
    event TakeBack(address borrower, uint256 _bookId);

    /**
    constructor
     */
    constructor(string memory name_) {
        _name = name_;
        bookstore.push(
            Book({
                isbn: "9781853260315",
                title: "20,000 Leagues Under the Sea (Wordsworth Classics)",
                author: "Jules Verne"
            })
        );
    }

    /**
Return library name
 */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * Add new Book
     */
    function addBook(
        string memory _isbn,
        string memory _title,
        string memory _author
    ) public onlyOwner {
        bookstore.push(Book({isbn: _isbn, title: _title, author: _author}));
    }

    function addBookById(uint256 _bookId)
        external
        view
        onlyValidBookId(_bookId)
        returns (
            uint256 bookId,
            string memory isbn,
            string memory title,
            string memory author,
            address borrower
        )
    {
        Book storage book = bookstore[_bookId];
        bookId = _bookId;
        isbn = book.isbn;
        title = book.title;
        author = book.author;
        borrower = ledger[_bookId];
    }

    /**
    Function: borrowingBook
    Input: bookId
    Return: boolean
     */

    function isBorrowing(uint256 _bookId)
        public
        view
        onlyValidBookId(_bookId)
        returns (bool)
    {
        return msg.sender == _getBorrowerByBookId(_bookId);
    }

    function isAvailable(uint256 _bookId)
        public
        view
        onlyValidBookId(_bookId)
        returns (bool)
    {
        return ledger[_bookId] == address(0);
    }

    modifier onlyBorrowable(uint256 _bookId) {
        require(
            !isBorrowing(_bookId) && isAvailable(_bookId),
            "Not available or already borrowed by you."
        );
        _;
    }

    modifier onlyValidBookId(uint256 _bookId){
        require(!isBorrowing(_bookId),"BookId is Not valid");
        _;
    }

    /**
     Funtion: borrow

    Input: _bookId
      */

    function borrow(uint256 _bookId) public onlyBorrowable(_bookId) {
        ledger[_bookId] = msg.sender;
        emit Borrow(msg.sender, _bookId);
    }

    /**
      Function: borrow
      Input: _bookId
       */

    function takeBack(uint256 _bookId) public {
        require(isBorrowing(_bookId), "Can Only return borrowing book");

        ledger[_bookId] = address(0);
        emit TakeBack(msg.sender, _bookId);
    }

    function _getBorrowerByBookId(uint256 _bookId) public view returns (address){
        return ledger[_bookId];
    }   

    struct Book {
        string isbn;
        string title;
        string author;
    }
}
