module Models exposing (Book, BookButtons, ClickMsg, initialBook)

import Array exposing (..)


type alias Book =
    { title : String
    , author : String
    , isbn : String
    , parts : Array Section
    }


type Section
    = Part { name : String, children : Array Section }
    | Chapter { name : String, completionStatus : Completion }


type Completion
    = NotRead ReadStatus
    | NotMastered MasteryStatus
    | Mastered


type ReadStatus
    = Unread
    | ExercisesPending
    | Read


type MasteryStatus
    = NeedsResearch
    | NeedsPractice


type alias BookButtons a =
    { a | completionStatus : Maybe Completion, name : String }


type alias ClickMsg =
    { partIdx : Int
    , chapterIdx : Int
    , mastery : String
    , msgType : Completion
    }


initialBook : Book
initialBook =
    Book
        "Cracking the Coding Interview"
        "Gayle Laakmann McDowell"
        "9780984782857"
        (Array.fromList
            [ Chapter
                { name = "Big-O Notation"
                , completionStatus = NotRead Unread
                }
            , Part
                { name = "Data Structures"
                , children =
                    Array.fromList
                        [ Chapter { name = "Arrays and Strings", completionStatus = NotRead Unread }
                        , Chapter { name = "Linked Lists", completionStatus = NotRead Unread }
                        , Chapter { name = "Stacks and Queues", completionStatus = NotRead Unread }
                        , Chapter { name = "Trees and Graphs", completionStatus = NotRead Unread }
                        ]
                }
            , Part
                { name = "Concepts and Algorithims"
                , children =
                    Array.fromList
                        [ Chapter { name = "Bit Manipulation", completionStatus = NotRead Unread }
                        , Chapter { name = "Math & Logic Puzzles", completionStatus = NotRead Unread }
                        , Chapter { name = "Object Oriented Design", completionStatus = NotRead Unread }
                        , Chapter { name = "Recursion and Dynamic Programming", completionStatus = NotRead Unread }
                        , Chapter { name = "System Design and Scalability", completionStatus = NotRead Unread }
                        , Chapter { name = "Sorting and Searching", completionStatus = NotRead Unread }
                        , Chapter { name = "Testing", completionStatus = NotRead Unread }
                        ]
                }
            , Part
                { name = "Knowledge Based"
                , children =
                    Array.fromList
                        [ Chapter { name = "C and C++", completionStatus = NotRead Unread }
                        , Chapter { name = "Java", completionStatus = NotRead Unread }
                        , Chapter { name = "Databases", completionStatus = NotRead Unread }
                        , Chapter { name = "Threads and Locks", completionStatus = NotRead Unread }
                        ]
                }
            , Part
                { name = "Advanced Topics"
                , children =
                    Array.fromList
                        [ Chapter { name = "Useful Math", completionStatus = NotRead Unread }
                        , Chapter { name = "Topological Sort", completionStatus = NotRead Unread }
                        , Chapter { name = "Dijkstra's Algorithm", completionStatus = NotRead Unread }
                        , Chapter { name = "Hash Table Collision Resolution", completionStatus = NotRead Unread }
                        , Chapter { name = "Rabin-Karp Substring Search", completionStatus = NotRead Unread }
                        , Chapter { name = "AVL Trees", completionStatus = NotRead Unread }
                        , Chapter { name = "Red-Black Trees", completionStatus = NotRead Unread }
                        , Chapter { name = "MapReduce", completionStatus = NotRead Unread }
                        , Chapter { name = "Additional Studying", completionStatus = NotRead Unread }
                        ]
                }
            , Part
                { name = "Code Library"
                , children =
                    Array.fromList
                        [ Chapter { name = "HashMapList<T,E>", completionStatus = NotRead Unread }
                        , Chapter { name = "TreeNode (Binary Search Tree)", completionStatus = NotRead Unread }
                        , Chapter { name = "LinkedListNode (Linked List)", completionStatus = NotRead Unread }
                        , Chapter { name = "Trie & TrieNode", completionStatus = NotRead Unread }
                        ]
                }
            ]
        )
