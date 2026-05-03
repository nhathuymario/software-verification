import { defineConfig } from "vite"
import react from "@vitejs/plugin-react"

const backendUrl = process.env.VITE_BACKEND_URL || "http://localhost:8081"

export default defineConfig({
    plugins: [react()],

    // Dùng khi chạy npm run dev
    server: {
        host: "0.0.0.0",
        port: 5173,
        proxy: {
            "/api": {
                target: backendUrl,
                changeOrigin: true,
                secure: false,
            },
            "/uploads": {
                target: backendUrl,
                changeOrigin: true,
                secure: false,
            },
        },
    },

    // Dùng khi chạy npm run preview trên EC2/Docker
    preview: {
        host: "0.0.0.0",
        port: 4173,
        allowedHosts: [
            "interuth.click",
            "www.interuth.click",
        ],
    },
})