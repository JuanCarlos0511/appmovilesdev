-- =============================================================
-- SUPABASE SETUP - Mascotas App
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- =============================================================

-- 1. TABLA MASCOTAS
--    id: UUID autogenerado
--    nombre, especie: texto requerido
--    edad: entero requerido
--    user_id: FK a auth.users (para seguridad por usuario)
--    created_at: timestamp automático
-- =============================================================

CREATE TABLE IF NOT EXISTS public.mascotas (
  id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre     TEXT        NOT NULL,
  especie    TEXT        NOT NULL,
  edad       INTEGER     NOT NULL CHECK (edad >= 0),
  user_id    UUID        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================
-- 2. ROW LEVEL SECURITY (RLS)
--    Cada usuario solo puede ver y modificar SUS mascotas
-- =============================================================

ALTER TABLE public.mascotas ENABLE ROW LEVEL SECURITY;

-- SELECT
CREATE POLICY "Usuarios ven sus mascotas"
  ON public.mascotas
  FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT
CREATE POLICY "Usuarios insertan sus mascotas"
  ON public.mascotas
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- UPDATE
CREATE POLICY "Usuarios actualizan sus mascotas"
  ON public.mascotas
  FOR UPDATE
  USING (auth.uid() = user_id);

-- DELETE
CREATE POLICY "Usuarios eliminan sus mascotas"
  ON public.mascotas
  FOR DELETE
  USING (auth.uid() = user_id);

-- =============================================================
-- 3. ÍNDICE para búsquedas por usuario (opcional pero recomendado)
-- =============================================================

CREATE INDEX IF NOT EXISTS mascotas_user_id_idx ON public.mascotas(user_id);

-- =============================================================
-- 4. CONFIGURACIÓN DE AUTH en Supabase Dashboard
--    (No requiere SQL, son ajustes en la UI)
--
--    Authentication → Settings:
--      - "Enable email confirmations": puedes desactivarlo
--        para pruebas (Site URL → Confirm email → OFF)
--      - Site URL: http://localhost (para desarrollo)
--
--    Authentication → Email Templates:
--      - Personaliza los correos de confirmación si lo activas
-- =============================================================

-- =============================================================
-- NOTAS FINALES
-- Después de ejecutar este script:
--   1. Ve a lib/app/core/values/supabase_config.dart
--   2. Reemplaza YOUR_SUPABASE_URL      con  Project Settings → API → Project URL
--   3. Reemplaza YOUR_SUPABASE_ANON_KEY con  Project Settings → API → anon / public key
-- =============================================================
