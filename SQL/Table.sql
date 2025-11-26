

admin 

id  PK
email VARCHAR UNIQUE
password_hash VARCHAR
created_at TIMESTAMP

courses

id UUID PK
title VARCHAR
description TEXT
thumbnail_url TEXT
published BOOLEAN
created_at TIMESTAMP
updated_at TIMESTAMP


modules


id UUID PK
course_id FK
title VARCHAR
position INT
created_at TIMESTAMP


videos


id UUID PK
module_id FK
title VARCHAR
description TEXT
video_url TEXT
duration INT
position INT
created_at TIMESTAMP


orders

id UUID PK
user_id VARCHAR
total_amount DECIMAL
payment_status VARCHAR
created_at TIMESTAMP

enrollments

id UUID PK
user_id VARCHAR
course_id UUID FK
created_at TIMESTAMP
