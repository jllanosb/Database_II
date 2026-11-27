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
IF DB_ID ('Turismo_JLLB') is not null
begin
	DROP DATABASE Turismo_JLLB;
	print 'Base de datos Turismo_JLLB Eliminada';
end
go

--Crear la base de datos
CREATE DATABASE Turismo_JLLB;
print 'Se ha creado la base de datos Turismo_JLLB';
go

--usar la base de datos creado
use Turismo_JLLB;
print 'Usando Turismo_JLLB';
go

--Crear esquema
if SCHEMA_ID(N'RRHH') is null
begin
	EXEC (N'Create Schema RRHH Authorization dbo;');
	print 'Esquema RRHH Creado';
end 
else
begin
	print 'Esquema RRHH existe';
end;
go

if SCHEMA_ID(N'Compras') is null
begin
	EXEC (N'Create Schema Compras Authorization dbo;');
	print 'Esquema Compras Creado';
end 
else
begin
	print 'Esquema Compras existe';
end;
go

if SCHEMA_ID(N'Ventas') is null
begin
	EXEC (N'Create Schema Ventas Authorization dbo;');
	print 'Esquema Ventas Creado';
end 
else
begin
	print 'Esquema Ventas existe';
end;
go

if SCHEMA_ID(N'UNC') is null
begin
	EXEC (N'Create Schema UNC Authorization dbo;');
	print 'Esquema UNC Creado';
end 
else
begin
	print 'Esquema UNC existe';
end;
go

if SCHEMA_ID(N'JLLB') is null
begin
	EXEC (N'Create Schema JLLB Authorization dbo;');
	print 'Esquema JLLB Creado';
end 
else
begin
	print 'Esquema JLLB existe';
end;
go

if SCHEMA_ID(N'Hospedaje') is null
begin
	EXEC (N'Create Schema Hospedaje Authorization dbo;');
	print 'Esquema Hospedaje Creado';
end 
else
begin
	print 'Esquema Hospedaje existe';
end;
go

if SCHEMA_ID(N'Lugar') is null
begin
	EXEC (N'Create Schema Lugar Authorization dbo;');
	print 'Esquema Lugar Creado';
end 
else
begin
	print 'Esquema Lugar existe';
end;
go

if SCHEMA_ID(N'Transporte') is null
begin
	EXEC (N'Create Schema Transporte Authorization dbo;');
	print 'Esquema Transporte Creado';
end 
else
begin
	print 'Esquema Transporte existe';
end;
go
/*
Creacion de Tablas
-- Validar Existencia
-- Crear la Tabla
*/
-- Crear Tabla Pais
if OBJECT_ID('JLLB.Pais', 'U') is not null
begin
	Drop Table JLLB.pais;
	print 'La tabla JLLB.Pais Eliminada'; 
end
go

CREATE TABLE JLLB.Pais (
	--primera forma poner PK
	idpais int primary key identity(1,1),
	nombrepais varchar(40) not null,
	codigoiso varchar(3) not null, --PER, ARG, CHL, COL
	fecha_registro datetime default getdate(),
	constraint UQ_nombrepais
	UNIQUE (nombrepais),
	constraint UQ_codigoiso
	UNIQUE (codigoiso)
);
print 'La tabla jllb.Pais creada';
go

--crear tabla nacionalidad
if OBJECT_ID('JLLB.Nacionalidad', 'U') is not null
begin
	Drop Table JLLB.Nacionalidad;
	print 'La tabla JLLB.Nacionalidad Eliminada'; 
end
go

CREATE TABLE JLLB.Nacionalidad (
	idnacionalidad int identity(1,1),
	nomnacionalidad varchar(80) not null,
	idpais int not null,
	fecha_registro datetime default getdate(),
	constraint PK_nacionalidad
	primary key (idnacionalidad),
	constraint UQ_nacionalidad
	UNIQUE (nomnacionalidad),
	constraint FK_pais_nacionalidad
	foreign key (idpais) References JLLB.pais (idpais)
);
print 'Tabla Nacionalidad Creada';
go

--Crear tabla region (Departamento)
if OBJECT_ID('JLLB.Region', 'U') is not null
begin
	Drop Table JLLB.Region;
	print 'La tabla JLLB.Region Eliminada'; 
end
go

CREATE TABLE JLLB.Region (
	idregion int identity (1,1),
	nomregion varchar (80) not null,
	codigoubigeo varchar(3) not null,--CAJ, LIM, CUS
	idpais int not null,
	fecha_registro datetime default getdate(),
	constraint PK_region primary key (idregion),
	constraint UQ_nomregion UNIQUE (nomregion),
	constraint FK_region_pais
	foreign key (idpais) References JLLB.Pais (idpais)
);
print 'Tabla Region Creada';
go

--Crear tabla subregion (Provincia)
if OBJECT_ID('JLLB.SubRegion', 'U') is not null
begin
	Drop Table JLLB.SubRegion;
	print 'La tabla JLLB.SubRegion Eliminada'; 
end
go

CREATE TABLE jllb.Subregion (
	idsubregion int identity(1,1),
	nomsubregion nvarchar(100) not null,
	codigo_ubigeo varchar(4) not null,
	idregion int not null,
	fecha_registro datetime default getdate(),
	constraint PK_subregion primary key (idsubregion),
	constraint FK_subregion_region
	foreign key (idregion)
	references jllb.region (idregion)
);
print 'Tabla Subregion creada';
go

--Crear tabla ciudad o distrito
if OBJECT_ID('JLLB.ciudad', 'U') is not null
begin
	Drop Table JLLB.Ciudad;
	print 'La tabla JLLB.Ciudad Eliminada'; 
end
go

CREATE TABLE JLLB.Ciudad (
	idciudad int identity(1,1),
	nomciudad varchar(80) not null,
	codigo_ubigeo varchar(6),
	idsubregion int not null,
	fecha_registro datetime default getdate(),
	constraint PK_ciudad primary key (idciudad),
	constraint FK_ciudad_subregion
	foreign key (idsubregion)
	References JLLB.Subregion (idsubregion)
);
print 'Tabla Ciudad creada';
go

--Crear tabla Tipo_documento
if OBJECT_ID('RRHH.TipoDocumento', 'U') is not null
begin
	Drop Table RRHH.TipoDocumento;
	print 'La tabla RRHH.TipoDocumento Eliminada'; 
end
go

CREATE TABLE RRHH.TipoDocumento(
	idtipodocumento int identity(1,1),
	nombredoc varchar(50) not null,
	abreviatura char(10) not null,
	fecha_registro datetime default getdate(),
	constraint PK_tipodocumento
	primary key (idtipodocumento),
	constraint UQ_nombredoc UNIQUE (nombredoc),
	constraint UQ_abreviatura UNIQUE (abreviatura)
);
print 'Tabla TipoDocumento Creado';
go

--Crear tabla Persona 
if OBJECT_ID('RRHH.Persona', 'U') is not null
begin
	Drop Table RRHH.Persona;
	print 'La tabla RRHH.Persona Eliminada'; 
end
go

CREATE TABLE RRHH.Persona (
	idpersona int identity(1,1),
	tipo_persona char(1) not null --N: Natural,J:Juridica
	constraint CHK_tipo_persona
	CHECK (tipo_persona in ('N', 'J')),
	
	nombres varchar(100),
	apaterno varchar(100),
	amaterno varchar(100),

	razon_social varchar (200) not null,
	nombre_comercial varchar(200),

	idtipodocumento int not null,
	numero_documento varchar(20) not null,
	telefono varchar(20)
	constraint CHK_numero_telefono
	CHECK (LEN(Ltrim(RTRIM(telefono))) between 12 and 20
	and telefono not like '%[^0-9+()]%'),
	--+51987654321, (+51)987654321, (01) 654321
	email varchar(150),
	idnacionalidad int not null,
	estado varchar(20) default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_estado
	CHECK (estado in ('Activo', 'Inactivo')),

	constraint PK_persona primary key (idpersona),
	constraint UQ_persona_documento
	UNIQUE (idtipodocumento, numero_documento),

	constraint FK_Persona_tipodocumento
	foreign key (idtipodocumento)
	References RRHH.TipoDocumento (idtipodocumento),
	constraint FK_persona_nacionalidad
	foreign key (idnacionalidad)
	References JLLB.Nacionalidad (idnacionalidad)
);
print 'Tabla Persona Creada';
go

--Crear tabla Persona 
if OBJECT_ID('RRHH.Cargo', 'U') is not null
begin
	Drop Table RRHH.Cargo;
	print 'La tabla RRHH.Cargo Eliminada'; 
end
go

CREATE TABLE RRHH.Cargo (
	idcargo int identity(1,1),
	nomcargo varchar(50) not null,
	descripcion varchar(max),
	salario_base decimal(10,2) not null,
	fecha_registro datetime default getdate(),
	constraint PK_cargo Primary key (idcargo)
);
print 'Tabla Cargo Creada';
go

--Crear tabla Direccion 
if OBJECT_ID('jllb.Direccion', 'U') is not null
begin
	Drop Table jllb.Direccion;
	print 'La tabla jllb.Direccion Eliminada'; 
end
go

CREATE TABLE JLLB.Direccion (
	iddireccion int identity(1,1),
	idciudad int not null,
	tipo_calle nvarchar(50) not null, --Av. Jr. Psje. Prolong. AA.HH.
	calle nvarchar(200) not null, --Atahualpa
	numero nvarchar(10) default 'S/N', --1050, s/n
	referencia nvarchar(max),
	codigo_postal nvarchar(10) not null,
	constraint CHK_zip
	CHECK (len(codigo_postal) between 5 and 10), --06001
	latitud decimal (10,8) null,
	longitud decimal (10,8) null,
	altitud decimal (10,8) null,
	fecha_registro datetime default getdate(),
	constraint PK_direccion primary key (iddireccion),
	constraint FK_direccion_ciudad
	foreign key (idciudad) References jllb.ciudad(idciudad)
);
print 'Tabla Direccion Creada';
go

--Crear tabla Cliente 
if OBJECT_ID('Ventas.Cliente', 'U') is not null
begin
	Drop Table Ventas.Cliente;
	print 'La tabla Ventas.Cliente Eliminada'; 
end
go

CREATE TABLE Ventas.Cliente (
	idpersona int not null,
	constraint PK_Cliente primary key (idpersona),
	fecha_nacimiento date not null,
	genero varchar(20), --Masculino, Femenino, Empresa, No Especifica, Prefiero no decirlo
	preferencias_viaje varchar(150) null,
	contacto_emergencia varchar(150) null,
	telefono_emergencia varchar(20) null,
	observaciones varchar(max) null, -- Informacion adicional
	puntos_fidelidad int not null default 0,
	nivel_cliente varchar(20) not null default 'Basico', --Basico, Bronze, Plata, Oro
	fecha_registro datetime default getdate(),
	constraint FK_cliente_persona
	Foreign key (idpersona) References RRHH.Persona (idpersona)
);
print 'Tabla Cliente creada';
go

--Crear tabla Empleado 
if OBJECT_ID('RRHH.Empleado', 'U') is not null
begin
	Drop Table RRHH.Empleado;
	print 'La tabla RRHH.Empleado Eliminada'; 
end
go

CREATE TABLE RRHH.Empleado (
	idpersona int not null,
	constraint PK_empleado primary key (idpersona),
	idcargo int not null,
	constraint FK_cargo_empleado
	foreign key (idcargo) references RRHH.Cargo (idcargo),
	cod_empleado varchar(15) null,
	fecha_ingreso date not null,
	fecha_cese date null,
	tipo_contrato varchar(30) null,
	estado_laboral varchar(20) not null default 'Activo'
	constraint CHK_Estado_laboral
	CHECK (estado_laboral in ('Activo', 'Inactivo', 'Suspendido')),
	jornada_laboral varchar(30) null,
	regimen_laboral varchar(30) null,
	id_supervisor int null,
	contacto_emergencia varchar(150) null,
	telefono_emergencia varchar(20) null,
	observaciones varchar(max) null, -- Informacion adicional
	fecha_registro datetime default getdate(),
	constraint FK_empleado_persona
	Foreign key (idpersona) References RRHH.Persona (idpersona),
	constraint FK_empleado_supervisor
	Foreign key (id_supervisor) References RRHH.Persona (idpersona)
);
print 'Tabla Empleado Creada';
go

--Crear tabla Direccion_cliente 
if OBJECT_ID('Ventas.Direccion_Cliente', 'U') is not null
begin
	Drop Table Ventas.Direccion_Cliente;
	print 'La tabla Ventas.Direccion_Cliente Eliminada'; 
end
go

CREATE TABLE Ventas.Direccion_Cliente ( 
	idpersona int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not null,
	constraint CHK_tipo_direccion
	CHECK (tipo_direccion in ('Casa', 'Trabajo', 'Facturacion', 'Entrega')),
	es_principal bit not null default 0,
	estado_direccion varchar(20) not null default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_Estado_Direccion_Cliente
	CHECK (estado_direccion in ('Activo', 'Inactivo', 'Suspendido')),
	constraint PK_direccion_cliente
	primary key (idpersona, iddireccion),
	constraint FK_direccion_cliente_persona
	foreign key (idpersona) References RRHH.Persona (idpersona),
	constraint FK_direccion_cliente
	foreign key (iddireccion) References jllb.Direccion (iddireccion)
);
print 'Tabla Direccion Cliente Creada';
go

--Crear tabla Direccion_Empleado 
if OBJECT_ID('RRHH.Direccion_Empleado', 'U') is not null
begin
	Drop Table RRHH.Direccion_Empleado;
	print 'La tabla RRHH.Direccion_Empleado Eliminada'; 
end
go

CREATE TABLE RRHH.Direccion_Empleado (
	idpersona int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not null,
	constraint CHK_tipo_direccion_empleado
	CHECK (tipo_direccion in ('Casa', 'Trabajo')),
	es_principal bit not null default 0,
	estado_direccion varchar(20) not null default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_Estado_Direccion_Empleado
	CHECK (estado_direccion in ('Activo', 'Inactivo', 'Suspendido')),
	constraint PK_direccion_empleado
	primary key (idpersona, iddireccion),
	constraint FK_direccion_empleado_persona
	foreign key (idpersona) References RRHH.Persona (idpersona),
	constraint FK_direccion_empleado
	foreign key (iddireccion) References jllb.Direccion (iddireccion)
);
print 'Tabla Direccion Empleado Creada';
go

--Crear tabla Categoria_Proveedor
if OBJECT_ID('Compras.Categoria_Proveedor', 'U') is not null
begin
	Drop Table Compras.Categoria_Proveedor;
	print 'La tabla Compras.Categoria_Proveedor Eliminada'; 
end
go

CREATE TABLE Compras.Categoria_Proveedor (
	idcat_proveedor int identity (1,1),
	nomcat_proveedor varchar(60) not null,
	descripcion varchar(max),
	fecha_registro datetime default getdate(),
	constraint PK_cat_proveedor primary key (idcat_proveedor),
	constraint UQ_nombre_cat_proveedor  UNIQUE (nomcat_proveedor)
);
print 'Tabla Categoria Provedoor Creada';
go

--Crear tabla Proveedor
if OBJECT_ID('Compras.Proveedor', 'U') is not null
begin
	Drop Table Compras.Proveedor;
	print 'La tabla Compras.Proveedor Eliminada'; 
end
go

CREATE TABLE Compras.Proveedor (
	idpersona int not null,
	cod_proveedor varchar(15) null,
	fecha_inicio_relacion date not null,
	fecha_fin_relacion date null,
	sitio_web nvarchar(250) null,
	requiere_contrato bit not null default 0,
	estado_proveedor varchar(20) not null default 'Activo',
	observaciones nvarchar(max) null,
	idcat_proveedor int not null,
	fecha_registro datetime default getdate(),
	constraint PK_proveedor primary key (idpersona),
	constraint CHK_Estado_Proveedor
	CHECK (estado_proveedor in ('Activo', 'Inactivo', 'Suspendido')),
	constraint FK_proveedor_persona
	foreign key (idpersona) References RRHH.Persona(idpersona),
	constraint FK_cate_proveedor
	foreign key (idcat_proveedor) references Compras.Categoria_Proveedor (idcat_proveedor)
);
print 'Tabla Proveedor Creada';
go

--Crear tabla Direccion_Proveedor 
if OBJECT_ID('Compras.Direccion_Proveedor', 'U') is not null
begin
	Drop Table Compras.Direccion_Proveedor;
	print 'La tabla Compras.Direccion_Proveedor Eliminada'; 
end
go

CREATE TABLE Compras.Direccion_Proveedor (
	idpersona int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not null,
	constraint CHK_tipo_direccion_proveedor
	CHECK (tipo_direccion in ('Fiscal', 'Envio', 'Fisica', 'Atencion', 'Pago', 'Sucursal', 'Almacen', 'Operativa')),
	es_principal bit not null default 0,
	estado_proveedor varchar(20) not null default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_Estado_Direccion_Proveedor
	CHECK (estado_proveedor in ('Activo', 'Inactivo', 'Suspendido')),
	constraint PK_direccion_proveedor
	primary key (idpersona, iddireccion),
	constraint FK_direccion_empleado_persona
	foreign key (idpersona) References RRHH.Persona (idpersona),
	constraint FK_direccion_empleado
	foreign key (iddireccion) References jllb.Direccion (iddireccion)
);
print 'Tabla Direccion Proveedor Creada';
go

--Crear tabla Tipo_Alojamiento
if OBJECT_ID('Hospedaje.Tipo_Alojamiento', 'U') is not null
begin
	Drop Table Hospedaje.Tipo_Alojamiento;
	print 'La tabla Hospedaje.Tipo_Alojamiento Eliminada'; 
end
go

CREATE TABLE Hospedaje.Tipo_Alojamiento (
	idtipoalojamiento int identity(1,1),
	nombre_tipo varchar(50) not null, --Hotel, Casa de Campo, Hostal, 'Cabaña'
	descripcion nvarchar(max) null,
	icono_url varchar(255) null,
	fecha_registro datetime default getdate(),
	constraint PK_tipo_alojamiento primary key (idtipoalojamiento),
	constraint UQ_nombre_tipo_aloj
	UNIQUE (nombre_tipo)
);
print 'Tabla Tipo_Alojamiento Creado';
go

--Crear tabla Alojamiento
if OBJECT_ID('Hospedaje.Alojamiento', 'U') is not null
begin
	Drop Table Hospedaje.Alojamiento;
	print 'La tabla Hospedaje.Alojamiento Eliminada'; 
end
go

CREATE TABLE Hospedaje.Alojamiento (
	idalojamiento int identity(1,1),
	constraint PK_alojamiento primary key (idalojamiento),
	idtipoalojamiento int not null,
	constraint FK_tipoalojamiento
	foreign key (idtipoalojamiento) references Hospedaje.Tipo_alojamiento (idtipoalojamiento),
	nombre varchar(100) not null,
	telefono varchar(20),
	correo varchar(100),
	Categoria_Estrellas tinyint,
	fecha_registro datetime default getdate(),
	constraint CHK_categoria_estrellas
	check (categoria_estrellas between 1 and 5) --Aplica solo a hoteles
);
print 'Tabla Alojamiento Creada';
go

--Crear tabla Direccion_Alojamiento
if OBJECT_ID('Hospedaje.Direccion_Alojamiento', 'U') is not null
begin
	Drop Table Hospedaje.Direccion_Alojamiento;
	print 'La tabla Hospedaje.Direccion_Alojamiento Eliminada'; 
end
go

CREATE TABLE Hospedaje.Direccion_Alojamiento (
	idalojamiento int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not null default 'Fisica',
	referencia varchar(max),
	es_principal bit default 0,
	fecha_registro datetime default getdate(),
	constraint PK_dire_alojamiento
	primary key(idalojamiento, iddireccion),
	constraint FK_id_alojamiento 
	foreign key (idalojamiento) references 
	Hospedaje.Alojamiento (idalojamiento),
	constraint FK_id_direccion 
	foreign key (iddireccion) references jllb.Direccion(iddireccion)
);
print 'Tabla Direccion_Alojamiento creado';
go

--Crear tabla Proveedor_Alojamiento
if OBJECT_ID('Hospedaje.Proveedor_Alojamiento', 'U') is not null
begin
	Drop Table Hospedaje.Proveedor_Alojamiento;
	print 'La tabla Hospedaje.Proveedor_Alojamiento Eliminada'; 
end
go

CREATE TABLE Hospedaje.Proveedor_Alojamiento (
	idproveedoralojamiento int not null identity(1,1),
	idpersona int not null,
	idalojamiento int not null,
	fecha_registro datetime default getdate(),
	constraint PK_ProveedorAlojamiento primary key (idproveedoralojamiento),
	constraint FK_idpersona_provee_alojamiento
	foreign key (idpersona) references rrhh.persona (idpersona),
	constraint FK_idalojmaiento_provee_alojamiento
	foreign key (idalojamiento) references Hospedaje.alojamiento (idalojamiento)
);
print 'Tabla Proveedor_alojamiento creado';
go

--Crear tabla Tipo_Habitacion
if OBJECT_ID('Hospedaje.Tipo_Habitacion', 'U') is not null
begin
	Drop Table Hospedaje.Tipo_Habitacion;
	print 'La tabla Hospedaje.Tipo_Habitacion Eliminada'; 
end
go

CREATE TABLE Hospedaje.Tipo_Habitacion (
	idtipohabitacion int identity(1,1),
	nombrehabitacion varchar(50) not null,
	constraint PK_idtipohabitacion primary key (idtipohabitacion),
	constraint UQ_nomhabitacion Unique(nombrehabitacion),
	capacidad_persona int not null,
	descripcion varchar(max),
	fecha_registro datetime default getdate()
);
print 'Tabla Tipo_Habitacion creada';
go

--Crear tabla Habitacion
if OBJECT_ID('Hospedaje.Habitacion', 'U') is not null
begin
	Drop Table Hospedaje.Habitacion;
	print 'La tabla Hospedaje.Habitacion Eliminada'; 
end
go

CREATE TABLE Hospedaje.Habitacion (
	idhabitacion int identity(1,1),
	idpersona int not null,
	idalojamiento int not null,
	numero_habitacion varchar(10) not null,
	idtipohabitacion int not null,
	precio_noche decimal(10,2) not null,
	estado varchar (20) default 'Disponible',
	constraint CHK_estado_habitacion
	CHEck (estado in ('Disponible', 'Ocupado', 'Mantenimiento', 'Fuera Servicio')),
	descripcion varchar(max),
	fecha_registro datetime default getdate(),
	constraint PK_habitacion primary key (idhabitacion),
	constraint UQ_habitacion 
	unique (idpersona, numero_habitacion, idalojamiento),
	constraint FK_id_persona_habitacion
	foreign key (idpersona) references RRHH.persona(idpersona),
	constraint FK_id_alojamiento_habitacion
	foreign key (idalojamiento) references Hospedaje.Alojamiento(idalojamiento),
	constraint FK_id_tipo_habitacion
	foreign key (idtipohabitacion) references Hospedaje.Tipo_Habitacion(idtipohabitacion)
);
print 'Tabla Habitacion Creada';
go

--Crear tabla Lugar_turistico
if OBJECT_ID('Lugar.Lugar_turistico', 'U') is not null
begin
	Drop Table Lugar.Lugar_turistico;
	print 'La tabla Lugar.Lugar_turistico Eliminada'; 
end
go

CREATE TABLE Lugar.Lugar_turistico (
	idlugarturistico int identity(1,1),
	nombre varchar(200) not null,
	descripcion varchar(max) null,
	precio_entrada decimal (10,2) default 0.00,
	horario_apertura time not null,
	horario_cierre time not null,
	califacion decimal(3,2) default 0.00,
	estado varchar(20) default 'Activo',
	constraint pk_lugar_turistico primary key (idlugarturistico),
	constraint CHK_estado_lugar
	CHECK (estado in ('Activo', 'Inactivo', 'Temporalmente Cerrado'))
);
print 'Tabla Lugar_turistico creado';
go