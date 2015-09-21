describe("Solver", function() {
  var solver;
  var maze = {"width":4,"height":4,"grid":{"vertical":[[true,false,false,true],[false,true,true,false],[false,false,false,false],[true,true,true,true]],"horizontal":[[false,true,false,false],[false,true,false,true],[true,false,true,true],[false,true,false,true]]},"start":{"x":0,"y":0},"end":{"x":0,"y":3}};

  beforeEach(function() {
    solver = new Solver(maze);
  });

  it("should be able to solve a Maze", function() {
    solver.solve();
    expect(solver.path).toContain([true,true,true,true]);
  });
  
  it("should be able to render solved Maze as ASCII", function() {
    solver.solve();
    expect(solver.toString().indexOf("+")).toBeGreaterThan(-1)
  });

});
