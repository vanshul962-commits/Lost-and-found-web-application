package com.mycompany.milgaya.server;

import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;
import java.io.File;
import java.net.ServerSocket;

public class MilgayaLauncher {

    private static int findAvailablePort(int preferredPort) {
        for (int p = preferredPort; p < preferredPort + 50; p++) {
            try (ServerSocket ss = new ServerSocket(p)) {
                return p;
            } catch (Exception ignored) {
                // Port occupied, try next
            }
        }
        return preferredPort;
    }

    public static void main(String[] args) throws Exception {
        int defaultPort = 8085; // Default to 8085 to avoid clash with Oracle XE / TNSLSNR on 8080
        String portEnv = System.getenv("PORT");
        if (portEnv != null) {
            try {
                defaultPort = Integer.parseInt(portEnv);
            } catch (NumberFormatException ignored) {}
        }

        int port = findAvailablePort(defaultPort);

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);

        // Set base directory for work files / JSP compilation
        File baseDir = new File("target/tomcat-work");
        baseDir.mkdirs();
        tomcat.setBaseDir(baseDir.getAbsolutePath());

        tomcat.getConnector(); // Initialize default HTTP connector

        String docBase = "src/main/webapp";
        File docBaseFile = new File(docBase);
        if (!docBaseFile.exists()) {
            docBase = new File(".").getAbsolutePath();
        }

        ClassLoader classLoader = MilgayaLauncher.class.getClassLoader();

        // 1. Context at /milgaya
        Context ctx = tomcat.addWebapp("/milgaya", new File(docBase).getAbsolutePath());
        ctx.setParentClassLoader(classLoader);

        File targetClasses = new File("target/classes");
        if (targetClasses.exists()) {
            org.apache.catalina.WebResourceRoot resources = new org.apache.catalina.webresources.StandardRoot(ctx);
            resources.addPreResources(new org.apache.catalina.webresources.DirResourceSet(
                    resources, "/WEB-INF/classes", targetClasses.getAbsolutePath(), "/"));
            ctx.setResources(resources);
        }

        System.out.println("==================================================================");
        System.out.println("  🌟 MILGAYA - LOST & FOUND PLATFORM SERVER STARTED 🌟");
        System.out.println("  Access the application at:");
        System.out.println("  👉 http://localhost:" + port + "/milgaya");
        System.out.println("  👉 http://localhost:" + port + "/milgaya/home");
        System.out.println("==================================================================");

        tomcat.start();
        tomcat.getServer().await();
    }
}
