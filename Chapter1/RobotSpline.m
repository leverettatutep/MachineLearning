figure
for k=1:length(pos_n)
    nwu = [pos_n(k); pos_w(k); pos_u(k)];
    enu = C_enu_to_nwu' * nwu;
    ecf = enu_sys.enu_to_ecf(enu);
    geo = ecf_to_geo_olson(ecf, environ.ellip, environ.ustr);
    lat_out(k) = rad_to_deg(geo.lat);
    lon_out(k) = rad_to_deg(geo.lon);
    alt_out(k) = geo.alt;
end
plot3(lon_out,lat_out,m_to_km(alt_out),'k')
hold on
plot3(lon,lat,m_to_km(alt),'b')
scatter3(lon,lat,m_to_km(alt),'bo')
xlabel('Longitude (deg)')
ylabel('latitude (deg)')
zlabel('Altitude (m)')
box on; grid on

numberOfPoints = 10;
numberOfPoints = 3;
numberOfLines = numberOfPoints - 1;
numberOfPolys = numberOfPoints;
numberOfPathPoints = 4 * numberOfLines + 10 * numberOfPolys;
path = zeros(numberOfPathPoints,4);
point = zeros(numberOfPoints,4);
point(1,:) = [0 0 0 0];
point(2,:) = [1 -1 1 1];
point(3,:) = [0 0 0 2];
dt = .1;



function x = line(x1, x2, x3, t1, t2, t3, dt, n)
    delt = (t2-t1)/n;
    sb = (x2-x1)/(t2-t1);
    x = zeros(n,1);
    t = t1;
    for i = 1:n
        x(i,1) = x1 + sb * (t-t1);
        t = t + delt;
    end
end

function x = spline(x1, x2, x3, t1, t2, t3, dt, n)
    [a b c d e f tb] = robotSpline(x1, x2, x3, t1, t2, t3, dt);
    x = zeros(n,1);
    t = t2-dt;
    delt = dt/n;
    for i = 1:n
        h = (t - (t2-dt))/(2*dt);
        x(i,1)= a + b*h + c*h^2 + d*h^3 + e*h^4 + f*h^5;
        t = t + delt;
    end
end

function [a b c d e f tb] = robotSpline(x1, x2, x3, t1, t2, t3, dt)
    [sb xb tb se xe te] = getsxt(x1, x2, x3, t1, t2, t3, dt);
    a = xb;
    b = sb*(te - tb);
    c = 0;
    d = 2*(3*sb*(tb-te) + 2 * se*(tb-te)- 5*xb + 5*xe);
    e = -8*s*tb - 7*se*tb+8*sb*te+7*se*te+15*xb-15*xe;
    f = 3*(sb*(tb-te)+se*(tb-te)-2*xb+2*xe);
end

function [sb xb tb se xe te] = getsxt(x1, x2, x3, t1, t2, t3, dt)
    sb = (x2-x1)/(t2-t1);
    xb = x2 - sb * dt;
    tb = t2 - dt;
    se = (x3-x2)/(t3-t2);
    xe = x2 + se * dt;
    te = t2 + dt;
end