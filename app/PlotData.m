classdef PlotData
    properties  
        Sus
        Exp
        Inf
        Rec
        Med
        Dead
        Held
    end
    
    methods
        function obj = PlotData(sus, exp, inf, rec, med, dead, held)
            obj.Sus = sus;
            obj.Exp = exp;
            obj.Inf = inf;
            obj.Rec = rec;
            obj.Med = med;
            obj.Dead = dead;
            obj.Held = held;
        end
    end
end