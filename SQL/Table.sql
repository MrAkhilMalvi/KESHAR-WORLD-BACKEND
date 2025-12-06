

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


------------------------------------------------------

✅ INSERT FUNCTION

CREATE OR REPLACE FUNCTION admin_courses_insert_course(
    in_title character varying,
    in_price numeric,
    in_description character varying,
    in_is_free boolean,
    in_instructor character varying,
    in_original_price numeric,
    in_badge character varying,
    in_category character varying,
    in_thumbnail_url character varying
)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  new_id character varying;
BEGIN
   new_id := generate_table_id('CRS', 'seq_courses');
   
        INSERT INTO courses(
            id, title, price, description, is_free, 
            instructor, original_price, badge, category, 
            thumbnail_url, created_at, updated_at
        )
        VALUES (
            new_id, in_title, in_price, in_description, in_is_free,
            in_instructor, in_original_price, in_badge, in_category,
            in_thumbnail_url, NOW(), NOW()
        );
		
      RETURN new_id;

END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION admin_courses_insert_modules(
    p_id text,
    p_course_id text,
    p_module_title text,
    p_position int
)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  new_id character varying;
BEGIN
   new_id := generate_table_id('MOD', 'seq_modules');
   
        INSERT INTO course_modules(
        id, course_id, module_title, position, created_at, updated_at
    )
    VALUES (
        p_id, p_course_id, p_module_title, p_position, NOW(), NOW()
    );
		
      RETURN new_id;

END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION admin_courses_insert_videos(
    in_module_id character varying,
    in_title character varying,
    in_url character varying,
    in_duration integer,
    in_description character varying,
    in_position integer
)
RETURNS character varying
LANGUAGE plpgsql
AS $$
DECLARE
  new_id character varying;
BEGIN
   new_id := generate_table_id('VID', 'seq_videos');
   
        INSERT INTO videos(
            id, module_id, video_title, video_url, duration, 
            description, position, badge,created_at, updated_at
        )
        VALUES (
            new_id, in_module_id, in_title, in_url, in_duration,
            in_description, in_position, NOW(), NOW()
        );
		
      RETURN new_id;

END;
$$ LANGUAGE plpgsql;






---------------------------------------


CREATE OR REPLACE FUNCTION admin_courses_updation_course(
    in_id character varying,
    in_title character varying,
    in_price numeric,
    in_description character varying,
    in_is_free boolean,
    in_instructor character varying,
    in_original_price numeric,
    in_badge character varying,
    in_category character varying,
    in_thumbnail_url character varying
)
   RETURNS void AS $$
BEGIN
  UPDATE courses
    SET 
        title = in_title,
        price = in_price,
        description = in_description,
        is_free = in_is_free,
        instructor = in_instructor,
        original_price = in_original_price,
        badge = in_badge,
        category = in_category,
        thumbnail_url = in_thumbnail_url,
        updated_at = NOW()
    WHERE id = in_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION admin_courses_update_module(
    in_id text,
    in_module_title text,
    in_position int
)
RETURNS void AS $$
BEGIN
    UPDATE course_modules
    SET 
        module_title = in_module_title,
        position = in_position,
        updated_at = NOW()
    WHERE id = in_id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION admin_courses_update_videos(
    in_id character varying,
    in_module_id character varying,
    in_title character varying,
    in_url character varying,
    in_duration integer,
    in_description character varying,
    in_position integer
)
RETURNS void AS $$
BEGIN
    UPDATE videos
    SET 
        module_id = in_module_id,
        video_title = in_title ,
        video_url = in_url ,
        duration = in_duration , 
        description = in_description ,
        position = in_position,
        updated_at = NOW()

    WHERE id = in_id;
END;
$$ LANGUAGE plpgsql;


----------------------------------------------------

CREATE OR REPLACE FUNCTION admin_courses_select_all()
RETURNS TABLE (
    id character varying,
    title character varying,
    price numeric,
    description text,
    is_free boolean,
    instructor character varying,
    original_price numeric,
    badge character varying,
    category character varying,
    thumbnail_url character varying,
    created_at timestamp,
    updated_at timestamp
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.title,
        c.price,
        c.description,
        c.is_free,
        c.instructor,
        c.original_price,
        c.badge,
        c.category,
        c.thumbnail_url,
        c.created_at,
        c.updated_at
    FROM courses c
    ORDER BY c.created_at DESC;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION admin_courses_get_modules_by_course(
    in_course_id character varying
)
RETURNS TABLE (
    module_id character varying,
    module_title character varying,
    position integer,
    created_at timestamp
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        id,
        module_title,
        position,
        created_at
    FROM course_modules
    WHERE course_id = in_course_id
    ORDER BY position;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION admin_courses_get_videos_by_module(
    in_module_id character varying
)
RETURNS TABLE (
    video_id character varying,
    video_title character varying,
    video_url character varying,
    duration integer,
    description text,
    position integer,
    created_at timestamp
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        id,
        video_title,
        video_url,
        duration,
        description,
        position,
        created_at
    FROM videos
    WHERE module_id = in_module_id
    ORDER BY position;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION public.student_course_purchase_status(
	in_user_id character varying)
    RETURNS TABLE(id character varying, title character varying, price numeric, description text, is_free boolean, instructor character varying, original_price numeric, badge character varying, category character varying, thumbnail_url character varying, order_status character varying, access_start timestamp without time zone, access_end timestamp without time zone, is_access_active boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY
    SELECT 
        c.id,
        c.title,
        c.price,
        c.description,
        c.is_free,
        c.instructor,
        c.original_price,
        c.badge,
        c.category,
        c.thumbnail_url,

        COALESCE(o.status, 'not purchased') AS order_status,
        uc.access_start,
        uc.access_end,

        (uc.access_end > NOW()) AS is_access_active
        
    FROM user_courses uc
    INNER JOIN courses c ON c.id = uc.course_id
    
    LEFT JOIN LATERAL (
        SELECT *
        FROM orders
        WHERE user_id = in_user_id
          AND course_id = c.id
        ORDER BY id DESC
        LIMIT 1
    ) o ON TRUE

    WHERE uc.user_id = in_user_id   -- ONLY purchased courses
    ORDER BY uc.access_end DESC;

END;
$BODY$;




CREATE OR REPLACE FUNCTION public.student_courses_base_module(
	in_user_id character varying,
	in_course_id character varying)
    RETURNS TABLE(module_id character varying, course_id character varying, module_title character varying, "position" integer, is_access_active boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE 
    v_access_end timestamp;
BEGIN
    -- Check purchased access (safe match)
    SELECT access_end
    INTO v_access_end
    FROM user_courses uc
    WHERE uc.user_id = in_user_id
      AND TRIM(LOWER(uc.course_id)) = TRIM(LOWER(in_course_id))
    ORDER BY uc.access_end DESC
    LIMIT 1;

    -- Active access
    IF v_access_end IS NOT NULL AND v_access_end > NOW() THEN
        RETURN QUERY
        SELECT 
            m.id,
            m.course_id,
            m.module_title,
            m.position,
            TRUE
        FROM course_modules m
        ORDER BY m.position;

        RETURN;
    END IF;

    -- Not purchased or expired
    RETURN QUERY
    SELECT 
        m.id,
        m.course_id,
        m.module_title,
        m.position,
        FALSE
    FROM course_modules m
    ORDER BY m.position;

END;
$BODY$;
