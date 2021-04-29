SQL

Content:
1. folder Maven_Movies_DB --  beginner/intermediate level query project (MySQL)
2. folder at_least_3NF_database --  university project the purpose of which is to create 20+ at least 3NF database tables.
    however, I tried to do 4NF rules. no content inside the tables
3. folder certificates --  some SQL courses certificates

<br>
<br>
<br>
<br>

1NF:
- Primary key (no duplicate tuples)	
- No repeating groups
- Atomic columns (cells have single value)

2NF:
- Be in 1NF
- Every non-trivial functional dependency either does not begin with a proper subset of a candidate key or ends with a prime attribute (no partial functional dependencies of non-prime attributes on candidate keys)

3NF:
- Be in 2NF
- Every non-trivial functional dependency either begins with a superkey or ends with a prime attribute (no transitive functional dependencies of non-prime attributes on candidate keys)[
