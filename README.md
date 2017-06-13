# Blocky game

The running app can be seen here: https://slyg.github.io/blocky/

## Quick installation and build 

You will need `docker` installed on your system.

Just run the `make` command to build the artefacts, located in the `/build` folder. It'll create a `slyg/blocky-game` image as well that you can run using the `make serve` command.

## Other available commands

Typing `make help` will give you the following options:

```
 make           alias for make build
 make build     builds projects as a docker image (slyg/blocky-game)
 make test      runs unit tests
 make serve     runs a slyg/blocky-game container exposing port 8080 (http://localhost:8080)
```

## Notes

I thought that starting by using elm, a statically typed and purely functional language, could help me reason about the algorithms I could use, however I haven't have had enough time to write it back in javascript :-/.

I used a recursive breadth first search (BFS) to find the siblings similar colors on the board (named kins in the code), though I'm not entirely sure the algo as is is implemented correctly. It might need more tests cases. See [here](https://github.com/slyg/blocky/blob/master/src/Board.elm#L177).

I actually use recursive functions several times, assuming that the board is not too complex and that a stack overflow risk is negligible. A JS runtime might not be the best for such approach I admit.