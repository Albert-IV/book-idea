module Models exposing (Book, Chapter, Mastery, Part, initialBook)


type alias Book =
    { title : String
    , author : String
    , isbn : String
    , parts : List Part
    }


type alias Part =
    { name : String
    , mastery : Maybe Mastery
    , chapters : List Chapter
    }


type alias Chapter =
    { name : String
    , mastery : Maybe Mastery
    }


type alias Mastery =
    { read : Bool
    , examples : Bool
    , moreResearch : Bool
    , morePractice : Bool
    }


initialBook : Book
initialBook =
    Book
        "Cracking the Coding Interview"
        "AYY"
        "9010"
        [ Part "Big O"
            Nothing
            [ Chapter "Big-O Notation" (emptyMastery True)
            ]
        , Part "Data Structures"
            Nothing
            [ Chapter "Arrays and Strings" (emptyMastery True)
            , Chapter "Linked Lists" (emptyMastery True)
            , Chapter "Stacks and Queues" (emptyMastery True)
            , Chapter "Trees and Graphs" (emptyMastery True)
            ]
        , Part "Concepts and Algorithims"
            Nothing
            [ Chapter "Bit Manipulation" (emptyMastery True)
            , Chapter "Math & Logic Puzzles" (emptyMastery True)
            , Chapter "Object Oriented Design" (emptyMastery True)
            , Chapter "Recursion and Dynamic Programming" Nothing
            , Chapter "System Design and Scalability" Nothing
            , Chapter "Sorting and Searching" Nothing
            , Chapter "Testing" Nothing
            ]
        , Part "Knowledge Based"
            Nothing
            [ Chapter "C and C++" Nothing
            , Chapter "Java" Nothing
            , Chapter "Databases" Nothing
            , Chapter "Threads and Locks" Nothing
            ]
        , Part "Advanced Topics"
            Nothing
            [ Chapter "Useful Math" Nothing
            , Chapter "Topological Sort" Nothing
            , Chapter "Dijkstra's Algorithm" Nothing
            , Chapter "Hash Table Collision Resolution" Nothing
            , Chapter "Rabin-Karp Substring Search" Nothing
            , Chapter "AVL Trees" Nothing
            , Chapter "Red-Black Trees" Nothing
            , Chapter "MapReduce" Nothing
            , Chapter "Additional Studying" Nothing
            ]
        , Part "Code Library"
            Nothing
            [ Chapter "HashMapList<T,E>" Nothing
            , Chapter "TreeNode (Binary Search Tree)" Nothing
            , Chapter "LinkedListNode (Linked List)" Nothing
            , Chapter "Trie & TrieNode" Nothing
            ]
        ]


emptyMastery : Bool -> Maybe Mastery
emptyMastery default =
    -- TODO: remove the initialization logic for read here
    Just (Mastery default False False False)
