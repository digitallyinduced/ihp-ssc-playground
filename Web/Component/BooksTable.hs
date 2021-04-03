module Web.Component.BooksTable where

import IHP.ViewPrelude hiding (fetch, query)
import Web.Controller.Prelude hiding (render, setState, getState)

import IHP.ServerSideComponent.Types as SSC
import IHP.ServerSideComponent.ControllerFunctions

import IHP.QueryBuilder
import qualified Database.PostgreSQL.Simple.ToField as PG
import qualified Data.Text as Text

data BooksTable = BooksTable
    { books :: Maybe [Book]
    , booksQuery :: SQLQuery
    }
    deriving (Eq, Show)

data BooksTableController
    = SetSearchQuery { searchQuery :: Text }
    | SetOrderBy { column :: Text }
    deriving (Eq, Show, Data, Read)

instance Component BooksTable BooksTableController where
    initialState = BooksTable {books = Nothing, booksQuery = buildQuery (query @Book) }

    componentDidMount = fetchBooks
    
    render BooksTable { .. } = [hsx|
        <table class="table">
            <thead class="thead-dark">
                <tr>
                    <th scope="col" onclick={callServerAction (SetOrderBy "title")}>Title</th>
                    <th scope="col" onclick={callServerAction (SetOrderBy "published_at")}>Published At</th>
                </tr>
            </thead>
            <tbody>
                {maybe mempty renderRows books}
            </tbody>
        </table>
        {when (isNothing books) loadingIndicator}
        <input type="text" value={inputValue searchQuery} onkeyup={onChange}/>
    |]
        where
            renderRows books = forEach books renderBook
            renderBook book = [hsx|
                <tr>
                    <td>{get #title book}</td>
                    <td>{get #publishedAt book}</td>
                </tr>
            |]

            onChange :: Text
            onChange = "callServerAction('SetSearchQuery { searchQuery = \"' + this.value + '\" }')"
            
            searchQuery :: Text
            searchQuery =
                booksQuery
                |> get #whereCondition
                |> \case
                    Just (VarCondition _ (PG.Escape searchQueryWithPercentage)) -> searchQueryWithPercentage
                            |> cs
                            |> Text.replace "%" ""
                    _ -> ""

    action state SetSearchQuery { searchQuery } = do
        let whereCondition = case searchQuery of
                "" -> Nothing
                query -> Just (VarCondition "title ILIKE ?" (PG.toField ("%" <> query <> "%")))

        state
            |> modify #booksQuery (set #whereCondition whereCondition)
            |> fetchBooks

    action state SetOrderBy { column } = do
        let orderByClause = [OrderByClause (cs column) Desc]

        state
            |> modify #booksQuery (set #orderByClause orderByClause)
            |> fetchBooks

fetchBooks :: _ => _
fetchBooks state = do
    books <- state
            |> get #booksQuery
            |> fetchSQLQuery

    state
        |> setJust #books books
        |> pure

loadingIndicator = [hsx|
    <div class="text-center">
        <div class="spinner-border" role="status">
            <span class="sr-only">Loading...</span>
        </div>
    </div>
|]

instance SetField "books" BooksTable (Maybe [Book]) where setField value' record = record { books = value' }
instance SetField "booksQuery" BooksTable SQLQuery where setField value' record = record { booksQuery = value' }