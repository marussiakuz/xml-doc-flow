-- Хранение XML в БД (BYTEA). Имя файла могло уже существовать при создании схемы через Hibernate.
ALTER TABLE document_versions ADD COLUMN IF NOT EXISTS xml_content BYTEA;
ALTER TABLE document_versions ADD COLUMN IF NOT EXISTS xml_file_name VARCHAR(512);

-- Старый путь: Hibernate больше не заполняет колонку — снимаем NOT NULL, чтобы INSERT без пути был допустим.
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = current_schema()
          AND table_name = 'document_versions'
          AND column_name = 'xml_file_path'
    ) THEN
        ALTER TABLE document_versions ALTER COLUMN xml_file_path DROP NOT NULL;
    END IF;
END $$;

-- Опционально, когда приложение перестанет маппить колонку:
-- ALTER TABLE document_versions DROP COLUMN IF EXISTS xml_file_path;
