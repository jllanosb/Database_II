/*
Base Datos para sector Turismo
------------------------------
Incluye Reservas, Clientes, Empleados, Transporte, Hospedaje
Lugares Turisticos, Proveedores ect.
*/

--USA BASE MODELO
use master;
go

--Validar existencia base de datos
IF DB_ID ('Turismo_JLLB') is null
begin
	DROP DATABASE Turismo_JLLB;
	print 'Base de datos Turismo_JLLB Eliminada';
end
go

--Crear la base de datos
CREATE DATABASE Turismo_JLLB;
print 'Se ha creado la base de datos Turismo_JLLB';
go

--Crear esquema
if SCHEMA_ID(N'RRHH') is null
exec (N'Create Schema RRHH Autorization dbo;');
go
print 'Se ha creado el esquema RRHH';
go

if SCHEMA_ID(N'Compras') is null
exec (N'Create Schema Compras Autorization dbo;');
go
print 'Se ha creado el esquema Compras';
go

if SCHEMA_ID(N'Ventas') is null
exec (N'Create Schema Ventas Autorization dbo;');
go
print 'Se ha creado el esquema Ventas';
go

if SCHEMA_ID(N'UNC') is null
exec (N'Create Schema unc Autorization dbo;');
go
print 'Se ha creado el esquema UNC';
go

if SCHEMA_ID(N'JLLB') is null
exec (N'Create Schema JLLB Autorization dbo;');
go
print 'Se ha creado el esquema JLLB';
go