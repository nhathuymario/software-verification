import { useEffect, useMemo, useRef, useState } from "react";
import { useNavigate } from "react-router-dom";
import { logout, getRoles, getToken } from "../services/auth";
import "../assets/css/components/Header.css";

import { HEADER_ACTIONS } from "../config/headerActions";
import { filterActionsByRoles } from "../utils/filterByRoles";
import { profileApi, type MeResponse } from "../services/profile";
import { goHomeByRole } from "../utils/navByRole";
import { notificationApi } from "../services/notification";
import uthImg from "../assets/uth-logo.png";


type HeaderProps = {
    username?: string;
    onProfile?: () => void;
    showMenu?: boolean;
};

export default function Header({ username, onProfile, showMenu = true }: HeaderProps) {
    const [open, setOpen] = useState(false);
    const [roles, setRoles] = useState<string[]>([]);
    const [me, setMe] = useState<MeResponse | null>(null);

    const [unreadCount, setUnreadCount] = useState(0);
    const nav = useNavigate();
    const ref = useRef<HTMLDivElement | null>(null);

    useEffect(() => {
        setRoles(getRoles());
    }, []);

    const hideBell = roles.includes("SYSTEM_ADMIN") || roles.includes("ADMIN_SYSTEM");

    // đóng menu khi click ngoài
    useEffect(() => {
        const handler = (e: MouseEvent) => {
            if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
        };
        document.addEventListener("click", handler);
        return () => document.removeEventListener("click", handler);
    }, []);

    useEffect(() => {
        const token = getToken?.() || localStorage.getItem("token");
        if (!token) return;

        (async () => {
            try {
                const c = await notificationApi.unreadCount();
                setUnreadCount(Number(c) || 0);
            } catch {
                // ignore
            }
        })();
    }, []);

    // ✅ lấy avatar từ /users/me (chỉ khi đã login)
    useEffect(() => {
        const token = getToken?.() || localStorage.getItem("token");
        if (!token) return;

        (async () => {
            try {
                const data = await profileApi.me();
                setMe(data);
            } catch {
                // ignore (token hết hạn / backend lỗi)
            }
        })();
    }, []);

    const handleLogout = () => logout();

    const handleProfile = () => {
        if (onProfile) onProfile();
        else nav("/profile");
        setOpen(false);
    };

    const handleGo = (to: string) => {
        nav(to);
        setOpen(false);
    };

    // ưu tiên fullName -> prop username -> localStorage username
    const displayName =
        me?.fullName?.trim() ||
        username ||
        localStorage.getItem("username") ||
        "Tài khoản";

    const badge = roles.join(", ") || "No role";

    const visibleActions = useMemo(
        () => filterActionsByRoles(HEADER_ACTIONS, roles),
        [roles]
    );

    // ⚠️ Nếu bạn dùng gateway thì đổi baseUrl cho đúng
    const avatarUrl = me?.profile?.avatarUrl || "";

    const initial = displayName.charAt(0).toUpperCase();

    return (
        <header className="header">
            <div className="brand" onClick={() => goHomeByRole(nav)}>
                <img src={uthImg} alt="Logo" />
            </div>

            {/* 🔔 Notification bell */}
            {showMenu && !hideBell && (
                <button
                    className="noti-btn"
                    onClick={() => nav("/notifications")}
                    title="Thông báo"
                >
                    🔔
                    {unreadCount > 0 && <span className="noti-badge">{unreadCount > 99 ? "99+" : unreadCount}</span>}
                </button>
            )}

            {showMenu && (
                <div ref={ref} className="user-box">
                    <button className="user-btn" onClick={() => setOpen(!open)}>
                        <div className="avatar">
                            {avatarUrl ? (
                                <img
                                    src={avatarUrl}
                                    alt="avatar"
                                    className="avatar-img"
                                    onError={(e) => {
                                        (e.currentTarget as HTMLImageElement).style.display = "none";
                                    }}
                                />
                            ) : (
                                initial
                            )}
                        </div>

                        <div className="user-text">
                            <div className="username">{displayName}</div>
                            <div className="role">{badge}</div>
                        </div>

                        <span className="caret">{open ? "▲" : "▼"}</span>
                    </button>

                    {open && (
                        <div className="menu">
                            {visibleActions.map((a) => (
                                <div
                                    key={a.key}
                                    className="menu-item"
                                    onClick={() => handleGo(a.to)}
                                >
                                    {a.icon ? `${a.icon} ` : ""}
                                    {a.label}
                                </div>
                            ))}

                            {visibleActions.length > 0 && <div className="menu-sep" />}

                            <div className="menu-item" onClick={handleProfile}>
                                Xem thông tin
                            </div>
                            <div className="menu-item logout" onClick={handleLogout}>
                                Đăng xuất
                            </div>
                        </div>
                    )}
                </div>
            )}
        </header>
    );

}
