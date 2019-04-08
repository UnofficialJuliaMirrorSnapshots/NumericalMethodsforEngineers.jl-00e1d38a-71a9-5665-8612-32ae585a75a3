using Calculus, QuadGK

function psm(nip)
  @test nip >= 1
  # Integrate to compute coefficient in rhs
  rhs(n, nip) = QuadGK.quadgk((x)-> x^nip, -n, n)[1]
  local hn
  if nip == 1
    w = [1.0]
  elseif nip == 2
    w = [1/2, 1/2]
  else
    if isodd(nip)
      n = floor(Int, nip/2)
      hn = linspace(-n, n, nip)
    else
      n = floor(Int, 2*(nip/2)-1)
      hn = linspace(-n, n, nip)
    end
    m = ones(nip, nip)
    for i in 0:nip-1
      for j in 1:nip
        m[i+1, j] = (hn[j])^i
      end
    end
    v = [rhs(n, ni) for ni in 0:nip-1]
    w = m \ v
    iseven(nip) && (w = w / 2.0)
  end
  w'
end

function nc(func, lb, ub, nip)
  @test ub > lb
  @test nip >= 1
  if nip == 1
    h = ub - lb
    x = [lb]
  elseif nip ==2
    h = ub - lb
    x = [lb, ub]
  else
    h = (ub - lb)/(nip-1)
    x = collect(linspace(lb, ub, nip))
  end
  w = psm(nip)
  res = h * w *func.(x)
  (w, res)
end

lb = pi/4
ub = pi/2
func = sin
for nip in 1:7
  w, res = nc(func, lb, ub, nip)
  println("Weigths vector: $w\nIntegrated value: $res\n")
end

println("QuadGK.quadgk = $(QuadGK.quadgk(sin, pi/4, pi/2)[1])\n")

