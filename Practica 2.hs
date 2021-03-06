sumatoria :: [Int] -> Int
sumatoria []     = 0
sumatotia (x:xs) = x + sumatoria xs

longitud :: [a] -> Int
longitud []     = 0
longitud (x:xs) = 1 + longitud xs

sucesores :: [Int] -> [Int]
sucesores []     = []
sucesores (x:xs) = sucesor x : sucesores xs


sucesor :: Int -> Int
sucesor x = x + 1

conjuncion :: [Bool] -> Bool
conjuncion []       = True
conjuncion (x : xs) = x && conjuncion xs

disyuncion :: [Bool] -> Bool
disyuncion []       = False
disyuncion (x : xs) = x || disyuncion xs

aplanar :: [[a]] -> [a]
aplanar []       = []
aplanar (xs : xss) = agregar xs (aplanar xss)

pertenece :: Eq a => a -> [a] -> Bool
pertenece e []     = False
pertenece e (x:xs) = x == e || pertenece e xs

apariciones :: Eq a => a -> [a] -> Int
apariciones e []     = 0
apariciones e (x:xs) = if e == x 
                        then 1 + apariciones e xs
                        else apariciones e xs

losMenoresA :: Int -> [Int] -> [Int]
losMenoresA n []     = []
losMenoresA n (x:xs) = if x < n
                        then x : losMenoresA n xs
                        else losMenoresA n xs

lasDeLongitudMayorA :: Int -> [[a]] -> [[a]]
lasDeLongitudMayorA n []     = []
lasDeLongitudMayorA n (x:xs) = if (longitud x) > n
                                then x : lasDeLongitudMayorA n xs
                                else lasDeLongitudMayorA n xs

agregarAlFinal :: [a] -> a -> [a]
agregarAlFinal [] e     = [e]
agregarAlFinal (x:xs) e = x : agregarAlFinal xs e

agregar :: [a] -> [a] -> [a]
agregar [] ys     = ys
agregar (x:xs) ys = x : agregar xs ys

reversa :: [a] -> [a]
reversa []     = []
reversa (x:xs) = agregarAlFinal (reversa xs) x

zipMaximos :: [Int] -> [Int] -> [Int]
zipMaximos [] ys         = ys
zipMaximos xs []         = xs
zipMaximos (x:xs) (y:ys) = max x y : zipMaximos xs ys
            

elMinimo :: Ord a => [a] -> a
elMinimo []       = error "no tiene elementos"
elMinimo [x]      = x
elMinimo (x:y:xs) =  min x (elMinimo xs)


------Recursión sobre números

factorial :: Int -> Int
factorial 0 = 1
factorial n= n * factorial (n-1)

cuentaRegresiva :: Int -> [Int]
cuentaRegresiva n = if n >= 1
                     then n : cuentaRegresiva (n-1)
                    else []

repetir :: Int -> a -> [a]
repetir 0 e = []
repetir n e = e : repetir (n-1) e

losPrimeros :: Int -> [a] -> [a]
losPrimeros _ [] = []
losPrimeros 0 xs =[]
losPrimeros n (x : xs) = x : losPrimeros (n-1) xs


sinLosPrimeros :: Int -> [a] -> [a]
sinLosPrimeros _ [] = []
sinLosPrimeros 0 xs = xs
sinLosPrimeros n (x:xs) = sinLosPrimeros (n-1) xs
---------------------------Registros --------------

data Persona = P String Int deriving Show 

mayoresA:: Int -> [Persona]-> [Persona]
mayoresA _ []     = []
mayoresA n (x:xs) = if edad x > n
                     then x : mayoresA n  xs
                     else mayoresA n xs

edad :: Persona -> Int
edad (P _ e) =  e

promedioDeEdad:: [Persona] -> Int
promedioDeEdad ps = div (sumarEdad ps) (longitud ps)

sumarEdad:: [Persona] -> Int
sumarEdad []     = 0
sumarEdad (x:xs) = edad x + sumarEdad xs

elMasViejo :: [Persona] -> Persona
elMasViejo [p]    = p
elMasViejo (p:ps) = if edad p > (edad (elMasViejo ps))
                      then p 
                      else elMasViejo ps

data TipoDePokemon = Agua | Fuego| Planta deriving Show         
data Pokemon       = ConsPokemon TipoDePokemon Int deriving Show 
data Entrenador    = ConsEntrenador String [Pokemon] deriving Show 

cantPokemon:: Entrenador -> Int 
cantPokemon (ConsEntrenador _ pks) = longitud pks

cantPokemonDe:: TipoDePokemon -> Entrenador -> Int
cantPokemonDe tipo (ConsEntrenador _ ps) =  cantPokemonDeMismoTipo tipo ps

cantPokemonDeMismoTipo:: TipoDePokemon -> [Pokemon] -> Int
cantPokemonDeMismoTipo tipo []     =  0
cantPokemonDeMismoTipo tipo (p:ps) = unoSi(mismoTipo tipo (tipoDe p)) + cantPokemonDeMismoTipo tipo ps

unoSi:: Bool -> Int
unoSi True  = 1
unoSi False = 0

mismoTipo:: TipoDePokemon -> TipoDePokemon -> Bool
mismoTipo Agua Agua    = True
mismoTipo Fuego Fuego  = True
mismoTipo Planta Planta= True
mismoTipo   _       _   = False

tipoDe:: Pokemon -> TipoDePokemon
tipoDe (ConsPokemon t n) = t

losQueLeganan:: TipoDePokemon -> Entrenador -> Entrenador -> Int
losQueLeganan t (ConsEntrenador _ ps1) (ConsEntrenador _ ps2) = ganadores t ps1 ps2

ganadores :: TipoDePokemon -> [Pokemon] -> [Pokemon] -> Int
ganadores t [] _        = 0
ganadores t (p:ps1) ps2 = unoSi(mismoTipo t (tipoDe p) && (leGananATodos p ps2)) + ganadores t ps1 ps2

leGananATodos :: Pokemon -> [Pokemon] -> Bool
leGananATodos p    []     = True
leGananATodos p (pkm:pks) = superaA (tipoDe p) (tipoDe pkm) && (leGananATodos p pks)

superaA :: TipoDePokemon -> TipoDePokemon -> Bool
superaA Agua Fuego   = True
superaA Fuego Planta = True
superaA Planta Agua  = True
superaA	_ _          = False
aCuantosLeGana:: TipoDePokemon -> [Pokemon] -> Int
aCuantosLeGana t []     = 0
aCuantosLeGana t (x:xs) = unoSi (superaA t (tipoDe x)) + aCuantosLeGana t xs


superaA :: TipoDePokemon -> TipoDePokemon -> Bool
superaA Agua Fuego   = True
superaA Fuego Planta = True
superaA Planta Agua  = True
superaA	_ _          = False


esMaestroPokemon:: Entrenador -> Bool
esMaestroPokemon (ConsEntrenador _ ps) = perteneceA ps Agua && perteneceA ps Fuego && perteneceA ps Planta

perteneceA:: [Pokemon] -> TipoDePokemon -> Bool
perteneceA  [] tipo= False
perteneceA (x:xs) tipo = mismoTipo tipo (tipoDe x) || perteneceA xs tipo




data Seniority = Junior | SemiSenior| Senior deriving Show
data Proyecto  = ConsProyecto String deriving Show
data Rol       = Developer Seniority Proyecto | Management Seniority Proyecto deriving Show
data Empresa   = ConsEmpresa [Rol] deriving Show

proyectos :: Empresa -> [Proyecto]
proyectos (ConsEmpresa rs) = sinProyectosRepetidos(listaDeProyectos rs)

listaDeProyectos :: [Rol] -> [Proyecto]
listaDeProyectos []     = []
listaDeProyectos (r:rs) = (proyectoDelRol r) : listaDeProyectos rs

proyectoDelRol :: Rol -> Proyecto
proyectoDelRol (Developer _ p)  = p
proyectoDelRol (Management _ p) = p

sinProyectosRepetidos:: [Proyecto] -> [Proyecto]
sinProyectosRepetidos []     = []
sinProyectosRepetidos (p:ps) = agregarSiHaceFalta p (sinProyectosRepetidos ps)

agregarSiHaceFalta :: Proyecto -> [Proyecto]-> [Proyecto]
agregarSiHaceFalta p ps = if perteneceP p ps		
							then ps
							else p:ps

perteneceP :: Proyecto -> [Proyecto] -> Bool
perteneceP p []     = False
perteneceP p (x:xs) = sonIguales x p || perteneceP p xs

sonIguales:: Proyecto -> Proyecto -> Bool
sonIguales (ConsProyecto p1) (ConsProyecto p2) = p1==p2

-------------------------
losDevSenior :: Empresa -> [Proyecto] -> Int
losDevSenior empresa ps= losQueTrabajanCon (totalDev empresa) ps

totalDev :: Empresa ->  [Rol]
totalDev (ConsEmpresa rs)= todosLosDev rs

todosLosDev :: [Rol] -> [Rol]
todosLosDev [] = []
todosLosDev (d:ds) = if esDev d && esSenior d
                      then d : todosLosDev ds
                      else todosLosDev ds

esDev :: Rol -> Bool
esDev (Developer s p) = True
esDev _               = False
 
esSenior :: Rol -> Bool
esSenior (Developer s p)= esSenioritySenior s
esSenior      _         = False

esSenioritySenior:: Seniority -> Bool
esSenioritySenior Senior = True
esSenioritySenior   _    = False

losQueTrabajanCon:: [Rol] -> [Proyecto] -> Int
losQueTrabajanCon rs [] = 0
losQueTrabajanCon rs (p:ps) = unoSi (perteneceARol p rs) + losQueTrabajanCon rs ps

perteneceARol :: Proyecto -> [Rol] -> Bool
perteneceARol p [] = False
perteneceARol p (x:xs) = sonIguales (proyecto x) p || perteneceARol p xs


proyecto :: Rol -> Proyecto
proyecto (Developer _ p) = p
proyecto (Management _ p) =  p

cantQueTrabajanEn :: [Proyecto] -> Empresa -> Int
cantQueTrabajanEn [] e = 0
cantQueTrabajanEn (p:ps) e = cantidadDeProyectosEn p e + cantQueTrabajanEn ps e

cantidadDeProyectosEn :: Proyecto -> Empresa -> Int
cantidadDeProyectosEn p (ConsEmpresa roles ) = cantProyectosEnR p roles

cantProyectosEnR :: Proyecto -> [Rol] -> Int
cantProyectosEnR p [] = 0
cantProyectosEnR p (r:rs) = unoSi (sonIguales p (proyecto r)) + cantProyectosEnR p rs

asignadosPorProyecto :: Empresa -> [(Proyecto,Int)]
asignadosPorProyecto (ConsEmpresa rs) = proyectosAsig rs

proyectosAsig :: [Rol] -> [(Proyecto,Int)]
proyectosAsig   []     = []
proyectosAsig (r:rs)   = agregarProyectos r (proyectosAsig rs)

agregarProyectos :: Rol -> [(Proyecto,Int)]-> [(Proyecto,Int)]
agregarProyectos  r []    = [(proyectoDelRol r,1)]
agregarProyectos r (p:ps) = if sonIguales (proyectoDelRol r) (fst p)
                              then(proyectoDelRol r, (snd p + 1)) : ps
			      else p : (agregarProyectos r ps)
					


