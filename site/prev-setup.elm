type alias BookSection =
    { name : String
    , mastery : Maybe Mastery

    -- the type ChildSection is a helper to allow recursive typing here
    , children : ChildSection
    }


type ChildSection
    = ChildSection (List BookSection)


type alias Mastery =
    { read : Bool
    , examples : Bool
    , moreResearch : Bool
    , morePractice : Bool
    }


initialBook : BookSection
initialBook =
    BookSection
        ("Cracking the Coding Interview" Nothing
            ChildSection ([ BookSection "Big O"
                Nothing
                ChildSection ([ BookSection "Big-O Notation" Mastery (False False False False) ChildSection [])
                ])
            , BookSection "Data Structures"
                Nothing
                ChildSection ([ BookSection "Arrays and Strings" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Linked Lists" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Stacks and Queues" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Trees and Graphs" Mastery (False False False False) ChildSection ( [] )
                ])
            , BookSection "Concepts and Algorithims"
                Nothing
                ChildSection( [ BookSection "Bit Manipulation" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Math & Logic Puzzles" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Object Oriented Design" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Recursion and Dynamic Programming" Mastery (False False False False) ChildSection ( [] )
                , BookSection "System Design and Scalability" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Sorting and Searching" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Testing" Mastery (False False False False) ChildSection ( [] )
                ])
            , BookSection "Knowledge Based"
                Nothing
                ChildSection ([ BookSection "C and C++" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Java" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Databases" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Threads and Locks" Mastery (False False False False) ChildSection ( [] )
                ])
            , BookSection "Advanced Topics"
                Nothing
                ChildSection                 ( [ BookSection "Useful Math" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Topological Sort" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Dijkstra's Algorithm" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Hash Table Collision Resolution" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Rabin-Karp Substring Search" Mastery (False False False False) ChildSection ( [] )
                , BookSection "AVL Trees" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Red-Black Trees" Mastery (False False False False) ChildSection ( [] )
                , BookSection "MapReduce" Mastery (False False False False) ChildSection ( [] )
                , BookSection "Additional Studying" Mastery (False False False False) ChildSection ( [] )
                ] )
            , BookSection "Code Library"
                Nothing
                ChildSection [ BookSection "HashMapList<T,E>" Mastery (False False False False) ChildSection []
                , BookSection "TreeNode (Binary Search Tree)" Mastery (False False False False) ChildSection []
                , BookSection "LinkedListNode (Linked List)" Mastery (False False False False) ChildSection []
                , BookSection "Trie & TrieNode" Mastery (False False False False) ChildSection []
                ]
            ]
        )


