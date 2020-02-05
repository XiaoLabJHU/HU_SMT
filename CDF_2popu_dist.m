function results = CDF_2popu_dist(s, t, pixSize_in_um, n)

[results.cum_d, results.d_all] = CumSD2(s, pixSize_in_um, n);
results.xx = results.cum_d.x(:);
results.yy = results.cum_d.ycum(:);
results.cdf_fit = fit(results.cum_d.x(:), results.cum_d.ycum(:),'1-a*exp(-x/(4*D1*0.00674))-(1-a)*exp(-x/(4*D2*0.00674))','StartPoint',[0.1 0.5 0.5]);

results.para = coeffvalues(results.cdf_fit);
results.errs = diff(confint(results.cdf_fit));
results.D1 = min(results.para(1), results.para(2));
ind = find(results.para == results.D1);
results.std_D1 = results.errs(ind);
results.D2 = max(results.para(1), results.para(2));
ind = find(results.para == results.D2);
results.std_D2 = results.errs(ind);

if results.para(1) < results.para(2)
    results.p1 = results.para(3);
    results.p2 = 1-results.para(3);
else
    results.p1 = 1-results.para(3);
    results.p2 = results.para(3);
end

results.std_p1 = results.errs(3);
results.std_p2 = results.errs(3);

results.g1 = (1 - exp(-results.cum_d.x./(4*results.D1*t)));
results.g2 = (1 - exp(-results.cum_d.x./(4*results.D2*t)));
results.g = results.cdf_fit(results.cum_d.x);

results.resid = results.yy(:) - results.g(:);
end