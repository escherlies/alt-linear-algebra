module Vector3 exposing (..)

import AltMath.Advanced.ADT.Vector3 as ADT
import AltMath.Advanced.Record.Vector3 as Record
import AltMath.Advanced.Tuple.Vector3 as Tuple
import AltMath.Const exposing (epsilon)
import Expect exposing (Expectation, FloatingPointTolerance(..))
import Fuzz
import Math.Vector3 as Math
import Test exposing (..)


suite : Test
suite =
    describe "Vector3!"
        [ fuzzWrap "getX" Math.getX ADT.getX Record.getX Tuple.getX
        , fuzzWrap "getY" Math.getX ADT.getX Record.getX Tuple.getX
        , fuzzWrap "getZ" Math.getZ ADT.getZ Record.getZ Tuple.getZ
        , fuzzWrapFloatVec "setX" Math.setX ADT.setX Record.setX Tuple.setX
        , fuzzWrapFloatVec "setY" Math.setY ADT.setY Record.setY Tuple.setY
        , fuzzWrapFloatVec "setZ" Math.setZ ADT.setZ Record.setZ Tuple.setZ
        , fuzzWrap2 "distance" Math.distance ADT.distance Record.distance Tuple.distance
        , fuzzWrap2 "distanceSquared" Math.distanceSquared ADT.distanceSquared Record.distanceSquared Tuple.distanceSquared
        , fuzzWrap2 "dot" Math.dot ADT.dot Record.dot Tuple.dot
        , fuzzWrap2Vec "cross" Math.cross ADT.cross Record.cross Tuple.cross
        , fuzzWrap "length" Math.length ADT.length Record.length Tuple.length
        , fuzzWrap "lengthSquared" Math.lengthSquared ADT.lengthSquared Record.lengthSquared Tuple.lengthSquared
        , fuzzWrap2Vec "add" Math.add ADT.add Record.add Tuple.add
        , fuzzWrap2Vec "sub" Math.sub ADT.sub Record.sub Tuple.sub
        , fuzzWrap2Vec "direction" Math.direction ADT.direction Record.direction Tuple.direction
        , fuzzWrapVec "negate" Math.negate ADT.negate Record.negate Tuple.negate
        , fuzzWrapVec "normalize" Math.normalize ADT.normalize Record.normalize Tuple.normalize
        , fuzzWrapFloatVec "scale" Math.scale ADT.scale Record.scale Tuple.scale
        ]


record : Fuzz.Fuzzer { x : Float, y : Float, z : Float }
record =
    Fuzz.map3 (\x y z -> { x = x, y = y, z = z })
        Fuzz.float
        Fuzz.float
        Fuzz.float


fuzzWrap : String -> (Math.Vec3 -> Float) -> (ADT.Vec3 -> Float) -> (Record.Vec3 -> Float) -> (Tuple.Vec3 -> Float) -> Test
fuzzWrap name fn0 fn1 fn2 fn3 =
    fuzz record name <|
        \r1 ->
            Expect.all
                [ Expect.within (Absolute epsilon) (fn1 (ADT.fromRecord r1))
                , Expect.within (Absolute epsilon) (fn2 (Record.fromRecord r1))
                , Expect.within (Absolute epsilon) (fn3 (Tuple.fromRecord r1))
                ]
                (fn0 (Math.fromRecord r1))


fuzzWrapVec : String -> (Math.Vec3 -> Math.Vec3) -> (ADT.Vec3 -> ADT.Vec3) -> (Record.Vec3 -> Record.Vec3) -> (Tuple.Vec3 -> Tuple.Vec3) -> Test
fuzzWrapVec name fn0 fn1 fn2 fn3 =
    fuzz record name <|
        \r1 ->
            Expect.all
                [ \{ x, y, z } ->
                    Expect.all
                        [ .x >> Expect.within (Absolute epsilon) x
                        , .y >> Expect.within (Absolute epsilon) y
                        , .z >> Expect.within (Absolute epsilon) z
                        ]
                        (fn1 (ADT.fromRecord r1) |> ADT.toRecord)
                , \{ x, y, z } ->
                    Expect.all
                        [ .x >> Expect.within (Absolute epsilon) x
                        , .y >> Expect.within (Absolute epsilon) y
                        , .z >> Expect.within (Absolute epsilon) z
                        ]
                        (fn2 (Record.fromRecord r1) |> Record.toRecord)
                , \{ x, y, z } ->
                    Expect.all
                        [ .x >> Expect.within (Absolute epsilon) x
                        , .y >> Expect.within (Absolute epsilon) y
                        , .z >> Expect.within (Absolute epsilon) z
                        ]
                        (fn3 (Tuple.fromRecord r1) |> Tuple.toRecord)
                ]
                (fn0 (Math.fromRecord r1) |> Math.toRecord)


fuzzWrap2 : String -> (Math.Vec3 -> Math.Vec3 -> Float) -> (ADT.Vec3 -> ADT.Vec3 -> Float) -> (Record.Vec3 -> Record.Vec3 -> Float) -> (Tuple.Vec3 -> Tuple.Vec3 -> Float) -> Test
fuzzWrap2 name fn0 fn1 fn2 fn3 =
    fuzz2 record record name <|
        \r1 r2 ->
            Expect.all
                [ Expect.within (Absolute epsilon) (fn1 (ADT.fromRecord r1) (ADT.fromRecord r2))
                , Expect.within (Absolute epsilon) (fn2 (Record.fromRecord r1) (Record.fromRecord r2))
                , Expect.within (Absolute epsilon) (fn3 (Tuple.fromRecord r1) (Tuple.fromRecord r2))
                ]
                (fn0 (Math.fromRecord r1) (Math.fromRecord r2))


fuzzWrap2Vec : String -> (Math.Vec3 -> Math.Vec3 -> Math.Vec3) -> (ADT.Vec3 -> ADT.Vec3 -> ADT.Vec3) -> (Record.Vec3 -> Record.Vec3 -> Record.Vec3) -> (Tuple.Vec3 -> Tuple.Vec3 -> Tuple.Vec3) -> Test
fuzzWrap2Vec name fn0 fn1 fn2 fn3 =
    fuzz2 record record name <|
        \r1 r2 ->
            Expect.all
                [ \{ x, y, z } ->
                    Expect.all
                        [ .x >> Expect.within (Absolute epsilon) x
                        , .y >> Expect.within (Absolute epsilon) y
                        , .z >> Expect.within (Absolute epsilon) z
                        ]
                        (fn1 (ADT.fromRecord r1) (ADT.fromRecord r2) |> ADT.toRecord)
                , \{ x, y, z } ->
                    Expect.all
                        [ .x >> Expect.within (Absolute epsilon) x
                        , .y >> Expect.within (Absolute epsilon) y
                        , .z >> Expect.within (Absolute epsilon) z
                        ]
                        (fn2 (Record.fromRecord r1) (Record.fromRecord r2) |> Record.toRecord)
                , \{ x, y, z } ->
                    Expect.all
                        [ .x >> Expect.within (Absolute epsilon) x
                        , .y >> Expect.within (Absolute epsilon) y
                        , .z >> Expect.within (Absolute epsilon) z
                        ]
                        (fn3 (Tuple.fromRecord r1) (Tuple.fromRecord r2) |> Tuple.toRecord)
                ]
                (fn0 (Math.fromRecord r1) (Math.fromRecord r2) |> Math.toRecord)


fuzzWrapFloatVec : String -> (Float -> Math.Vec3 -> Math.Vec3) -> (Float -> ADT.Vec3 -> ADT.Vec3) -> (Float -> Record.Vec3 -> Record.Vec3) -> (Float -> Tuple.Vec3 -> Tuple.Vec3) -> Test
fuzzWrapFloatVec name fn0 fn1 fn2 fn3 =
    fuzz2 record Fuzz.float name <|
        \r1 fl ->
            Expect.all
                [ \{ x, y, z } ->
                    Expect.all
                        [ .x >> Expect.within (Absolute epsilon) x
                        , .y >> Expect.within (Absolute epsilon) y
                        , .z >> Expect.within (Absolute epsilon) z
                        ]
                        (fn1 fl (ADT.fromRecord r1) |> ADT.toRecord)
                , \{ x, y, z } ->
                    Expect.all
                        [ .x >> Expect.within (Absolute epsilon) x
                        , .y >> Expect.within (Absolute epsilon) y
                        , .z >> Expect.within (Absolute epsilon) z
                        ]
                        (fn2 fl (Record.fromRecord r1) |> Record.toRecord)
                , \{ x, y, z } ->
                    Expect.all
                        [ .x >> Expect.within (Absolute epsilon) x
                        , .y >> Expect.within (Absolute epsilon) y
                        , .z >> Expect.within (Absolute epsilon) z
                        ]
                        (fn3 fl (Tuple.fromRecord r1) |> Tuple.toRecord)
                ]
                (fn0 fl (Math.fromRecord r1) |> Math.toRecord)
