--1. Base de datos principal
USE MASTER;
GO

--CREAR BASE DE DATOS
-- GRAFICO
-- CODIGO
--2. Validando existencia de la base de datos
IF OBJECT_ID('DEMO_UNC') IS NULL
BEGIN
	DROP DATABASE DEMO_UNC;
	print 'La Base de Datos DEMO_UNC eliminada';
END
GO
--3. Crear la base de datos
CREATE DATABASE DEMO_UNC;
print 'Base de datos DEMO_UNC creada correctamente';
GO

--4. Poner en uso la base de datos
USE DEMO_UNC;
print 'Esta usando DEMO_UNC';
GO