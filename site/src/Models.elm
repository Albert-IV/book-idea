module Models exposing (Book, BookButtons, Chapter, ClickMsg, Mastery, Part, RecordType(..), emptyMastery, initialBook)

import Array exposing (..)


type alias Book =
    { title : String
    , author : String
    , isbn : String
    , parts : Array Part
    }


type alias Part =
    { name : String
    , mastery : Maybe Mastery
    , chapters : Array Chapter
    }


type alias Chapter =
    { name : String
    , mastery : Maybe Mastery
    }


type alias BookButtons a =
    { a | mastery : Maybe Mastery, name : String }


type alias Mastery =
    { read : Bool
    , examples : Bool
    , moreResearch : Bool
    , morePractice : Bool
    }


type alias ClickMsg =
    { partIdx : Int
    , chapterIdx : Int
    , mastery : String
    , msgType : RecordType
    }


type RecordType
    = PartRecord
    | ChapterRecord


initialBook : Book
initialBook =
    Book
        "Cracking the Coding Interview"
        "AYY"
        "9010"
        (Array.fromList
            [ Part "Big O"
                (emptyMastery True)
                (Array.fromList [ Chapter "Big-O Notation" Nothing ])
            , Part "Data Structures"
                Nothing
                (Array.fromList
                    [ Chapter "Arrays and Strings" (emptyMastery True)
                    , Chapter "Linked Lists" (emptyMastery True)
                    , Chapter "Stacks and Queues" (emptyMastery True)
                    , Chapter "Trees and Graphs" (emptyMastery True)
                    ]
                )
            , Part "Concepts and Algorithims"
                Nothing
                (Array.fromList
                    [ Chapter "Bit Manipulation" (emptyMastery True)
                    , Chapter "Math & Logic Puzzles" (emptyMastery True)
                    , Chapter "Object Oriented Design" (emptyMastery True)
                    , Chapter "Recursion and Dynamic Programming" Nothing
                    , Chapter "System Design and Scalability" Nothing
                    , Chapter "Sorting and Searching" Nothing
                    , Chapter "Testing" Nothing
                    ]
                )
            , Part "Knowledge Based"
                Nothing
                (Array.fromList
                    [ Chapter "C and C++" Nothing
                    , Chapter "Java" Nothing
                    , Chapter "Databases" Nothing
                    , Chapter "Threads and Locks" Nothing
                    ]
                )
            , Part "Advanced Topics"
                (emptyMastery True)
                (Array.fromList
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
                )
            , Part "Code Library"
                (emptyMastery False)
                (Array.fromList
                    [ Chapter "HashMapList<T,E>" Nothing
                    , Chapter "TreeNode (Binary Search Tree)" Nothing
                    , Chapter "LinkedListNode (Linked List)" Nothing
                    , Chapter "Trie & TrieNode" Nothing
                    ]
                )
            ]
        )


emptyMastery : Bool -> Maybe Mastery
emptyMastery default =
    -- TODO: remove the initialization logic for read here
    Just (Mastery default False False False)
