--TIPOS RECURSIVOS SIMPLES

data Color = Azul| Rojo deriving Show 
data Celda = Bolita Color Celda | CeldaVacia deriving Show

nroBolitas::Color -> Celda -> Int
nroBolitas c CeldaVacia      = 0
nroBolitas c (Bolita col cel)= unoSi(esBolitaColor c col) + nroBolitas c cel

unoSi ::Bool -> Int
unoSi True  = 1
unoSi False = 0

esBolitaColor::Color -> Color -> Bool
esBolitaColor Azul Azul = True
esBolitaColor Rojo Rojo = True
esBolitaColor _ _       = False

--------------------------
poner::Color -> Celda -> Celda
poner c CeldaVacia      = Bolita c CeldaVacia
poner c (Bolita col cel)= Bolita col(poner c cel)

---------------------------
sacar::Color -> Celda -> Celda
sacar c CeldaVacia = CeldaVacia
sacar c (Bolita col cel) = if(esBolitaColor c col)
							 then cel	
							 else Bolita col (sacar c cel)
							 
							 
-----------------------------
ponerN:: Int -> Color -> Celda -> Celda
ponerN 0 col celda = celda
ponerN n col celda = ponerN(n-1) col (poner col celda)

------------Camino hacia el tesoro
data Objeto = Cacharro | Tesoro deriving Show 
data Camino = Fin | Cofre [Objeto] Camino | Nada Camino deriving Show 

hayTesoro :: Camino -> Bool
hayTesoro Fin              = False
hayTesoro (Nada camino)      = hayTesoro camino
hayTesoro (Cofre objs camino) = contieneTesoro objs || hayTesoro camino

contieneTesoro :: [Objeto] -> Bool
contieneTesoro    []    = False
contieneTesoro (o:objs) = esTesoro o || contieneTesoro objs

esTesoro:: Objeto -> Bool
esTesoro Tesoro = True
esTesoro _      = False

---------------
pasosHastaTesoro :: Camino -> Int
pasosHastaTesoro Fin                 = 0
pasosHastaTesoro (Nada camino)       = pasosHastaTesoro camino
pasosHastaTesoro (Cofre objs camino) = if contieneTesoro objs
											then pasosHastaTesoro camino
											else 1 + pasosHastaTesoro camino
											
----------
hayTesoroEn :: Int -> Camino -> Bool
hayTesoroEn 0 camino = hayTesoroEnActual camino
hayTesoroEn n camino = hayTesoroEn (n-1) (avanzarCamino camino)


hayTesoroEnActual:: Camino -> Bool
hayTesoroEnActual (Cofre objs camino) = contieneTesoro objs
hayTesoroEnActual      _              = False


avanzarCamino :: Camino -> Camino
avanzarCamino   Fin            = Fin
avanzarCamino (Cofre _ camino) = camino
avanzarCamino (Nada camino)    = camino 

---------------------
alMenosNTesoros :: Int -> Camino -> Bool
alMenosNTesoros n   Fin         = n == 0
alMenosNTesoros n (Nada camino) = alMenosNTesoros n camino
alMenosNTesoros n (Cofre obs camino) = (cantTesoro obs) >= n || (alMenosNTesoros (n - cantTesoro obs) camino)

cantTesoro :: [Objeto] -> Int
cantTesoro    []    = 0
cantTesoro (o: objs)= unoSi(esTesoro o) +(cantTesoro objs)


--(desafío) cantTesorosEntre :: Int -> Int -> Camino -> Int
--Dado un rango de pasos, indica la cantidad de tesoros que hay en ese rango. Por ejemplo, si
--el rango es 3 y 5, indica la cantidad de tesoros que hay entre hacer 3 pasos y hacer 5. Están
--incluidos tanto 3 como 5 en el resultado											


----------------- Árboles binarios
data Tree a = EmptyT | NodeT a (Tree a) (Tree a) deriving Show 

sumarT :: Tree Int -> Int
sumarT EmptyT          = 0
sumarT (NodeT x t1 t2) =  x + (sumarT t1) + (sumarT t2)

sizeT :: Tree a -> Int
sizeT   EmptyT       = 0
sizeT (NodeT x t1 t2)= 1 + (sizeT t1) + (sizeT t2)

mapDobleT :: Tree Int -> Tree Int
mapDobleT  EmptyT        = EmptyT
mapDobleT (NodeT x t1 t2)= NodeT (x*2) (mapDobleT t1) (mapDobleT t2)

perteneceT :: Eq a => a -> Tree a -> Bool
perteneceT x   EmptyT       = False
perteneceT x (NodeT y t1 t2)= (x==y) || (perteneceT y t1)|| (perteneceT y t2)

aparicionesT :: Eq a => a -> Tree a -> Int
aparicionesT x    EmptyT       = 0
aparicionesT x (NodeT y t1 t2) = if (x==y)
									then 1 + (aparicionesT y t1) + (aparicionesT y t2)
									else (aparicionesT y t1) + (aparicionesT y t2)
									
leaves :: Tree a -> [a]
leaves    EmptyT               = []								
leaves (NodeT x EmptyT EmptyT) = [x] 
leaves (NodeT x t1 t2)         = x :(leaves t1) ++ (leaves t2)

heightT :: Tree a -> Int
heightT  EmptyT         = 0
heightT (NodeT x t1 t2) = 1 + (max(heightT t1)(heightT t2))

mirrorT :: Tree a -> Tree a
mirrorT EmptyT          = EmptyT
mirrorT (NodeT x t1 t2) = NodeT x (mirrorT t2) (mirrorT t1)

toList :: Tree a -> [a]
toList  EmptyT        = []
toList (NodeT x t1 t2)= (toList t1) ++ [x] ++ (toList t2)

levelN :: Int -> Tree a -> [a] 
levelN _ EmptyT        = []
levelN 0 (NodeT x _ _) = [x]
levelN n (NodeT _ t1 t2) = levelN(n-1) t1 ++ levelN(n-1) t2

listPerLevel :: Tree a -> [[a]]
listPerLevel t = losNiveles t (heightT t-1)

losNiveles:: Tree a -> Int -> [[a]]
losNiveles t 0 = [levelN 0 t]
losNiveles t n = if n<0
				  then []
				  else levelN n t : losNiveles t (n-1)

--ramaMasLarga :: Tree a -> [a]
--Devuelve los elementos de la rama más larga del árbol

todosLosCaminos :: Tree a -> [[a]]
todosLosCaminos   EmptyT       = []
todosLosCaminos (NodeT x t1 t2)= agregarACadaSublista x ((todosLosCaminos t1) ++ (todosLosCaminos t2))


agregarACadaSublista:: a -> [[a]] -> [[a]]
agregarACadaSublista y   []     = [[y]]
agregarACadaSublista y (xs:xss) = (y:xs): agregarACadaSublista y xss

-----------------Expresiones Aritméticas

data ExpA = Valor Int| Sum ExpA ExpA| Prod ExpA ExpA| Neg ExpA deriving Show 
		  
eval :: ExpA -> Int
eval (Valor n)    = n
eval (Sum e1 e2)  = (eval e1) + (eval e2)
eval (Prod e1 e2) = (eval e1) * (eval e2)
eval (Neg e1 )    =  -(eval e1)

simplificar :: ExpA -> ExpA
simplificar (Valor n)   = Valor n
simplificar (Sum e1 e2) = armarSuma (simplificar e1) (simplificar e2)
simplificar (Prod e1 e2)= Prod (simplificar e1) (simplificar e2)
simplificar (Neg e1 )   = Neg (simplificar e1)

armarSuma:: ExpA -> ExpA -> ExpA
armarSuma (Valor 0) e2 = e2
armarSuma e1 (Valor 0) = e1
armarSuma e1 e2        = Sum e1 e2