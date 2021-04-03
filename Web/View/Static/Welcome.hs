module Web.View.Static.Welcome where
import Web.View.Prelude
import IHP.ServerSideComponent.ViewFunctions

import Web.Component.Counter
import Web.Component.BooksTable

data WelcomeView = WelcomeView

instance View WelcomeView where
    html WelcomeView = [hsx|
        <h1>Component playground</h1>

        <div class="mb-5">
            <h2>Counter demo</h2>
            {counter}
        </div>

        <hr />

        <div class="mb-5">
            <h2>Table demo</h2>
            {booksTable}
        </div>

        <script src="/vendor/ihp-ssc.js"></script>
    |]
        where
            counter = component @Counter
            booksTable = component @BooksTable