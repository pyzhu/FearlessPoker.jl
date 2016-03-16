using FearlessPoker
using FactCheck
using StatsBase

facts("Hand Parsing") do
  @fact Hand(13757003685786313) --> Hand("8d,Tc,Td,Th,Ts,Qh,Qs")
  @fact Hand(690690) --> Hand("2c,2d,2h,2s,3c,3d,4c")
end


# write your own tests here
facts("Hand evaluation") do
  @fact evaluate(Hand("Ah,Ad,Ac,As,Ts,8d,2c")) --> 814.1
  @fact evaluate(Hand("Ah,Ad,Ac,As,7s,8d,2c")) --> 814.08
  @fact evaluate(Hand("Ah,Kh,Th,Jh,Qh,9d,Td")) --> 914
  @fact evaluate(Hand("Ah,Ad,Ac,Td,Tc,2c,8s")) --> 714.10
  @fact evaluate(Hand("Ah,Kh,8h,Jh,Qh,9d,Td")) --> 614
  @fact evaluate(Hand("Ah,Jd,Qc,Ks,9d,Tc,2h")) --> 514
  @fact evaluate(Hand("Ah,Ad,2s,2c,9d,Td,Tc")) --> 314.1002
  @fact evaluate(Hand("Kc,Kd,9h,7c,5c,Tc,3h")) --> 213.100907
  @fact evaluate(Hand("Ah,Jc,9s,7s,7d,6h,4d")) --> 207.141109
  @fact evaluate(Hand("7s,Kc,4d,5c,8s,Jd,9s")) --> 113.11090807
  @fact evaluate(Hand("Qh,9h,4d,9c,Td,Jc,3d")) --> 209.121110
  @fact evaluate(Hand("2c,2d,5s,6h,Qc,Qs,Ad")) --> 312.0214
end

facts("Evaluate Straights") do
  @fact FearlessPoker.findstraight(Hand("Ah,2d,3c,4d,5s,9d,4h")) --> Hand("Ah,2d,3c,4d,4h,5s")
  @fact FearlessPoker.findstraight(Hand("Th,Jh,Qc,Ks,As,2d,3d")) --> Hand("Th,Jh,Qc,Ks,As")
  @fact FearlessPoker.findstraight(Hand("Ah,2s,3s,6d,7d,9s")) --> nothing
  @fact FearlessPoker.findstraight(Hand("2s,3s,4d,5d,6c,7c,8h")) --> Hand("4d,5d,6c,7c,8h")
  @fact FearlessPoker.findstraight(Hand("Ts,Jc,Qd,Ks,Ah")) --> Hand("Ts,Jc,Qd,Ks,Ah")
  @fact_throws AssertionError FearlessPoker.findstraight(Hand("2s,3s,4d"))
end

facts("Evaluate Flush") do
  @fact FearlessPoker.findflush(Hand("2d,3d,4d,7d,9d,Ah,Ks")) --> Hand("2d,3d,4d,7d,9d")
  @fact FearlessPoker.findflush(Hand("2d,3s,4d,5h,As,Kc")) --> nothing
end


facts("Mapping Hands to an Integer Id") do
  @fact convert(Integer, Hand("2d,3d,4d,7d,9d,Ah,Ks")) --> convert(Integer, Hand("2d,3d,9d,Ah,Ks,4d,7d"))

  @fact length(unique(map(h -> convert(Integer, FearlessPoker.Hand(h)), combinations(DECK, 4)))) --> length(combinations(1:52, 4))
end