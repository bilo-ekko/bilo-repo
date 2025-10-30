import { Button } from "@repo/ui/button";
import styles from "./page.module.css";

export default function Dashboard() {
  return (
    <div className={styles.page}>
      <header className={styles.header}>
        <h1>🚀 Dashboard</h1>
      </header>
      
      <main className={styles.main}>
        <div className={styles.hero}>
          <h2>Welcome to Your Dashboard</h2>
          <p>
            A modern, scalable dashboard built with Next.js 15, React 19, and integrated with Turborepo monorepo architecture.
          </p>
        </div>

        <div className={styles.cards}>
          <div className={styles.card}>
            <h3>📊 Analytics</h3>
            <p>
              Track your application metrics and performance data in real-time with our analytics service.
            </p>
          </div>

          <div className={styles.card}>
            <h3>💼 Portfolio</h3>
            <p>
              Manage your investment portfolio and view detailed insights about your holdings.
            </p>
          </div>

          <div className={styles.card}>
            <h3>💰 Transactions</h3>
            <p>
              View and manage all your financial transactions with advanced filtering options.
            </p>
          </div>

          <div className={styles.card}>
            <h3>🔒 Authentication</h3>
            <p>
              Secure user authentication and authorization powered by our auth service.
            </p>
          </div>

          <div className={styles.card}>
            <h3>📱 Projects</h3>
            <p>
              Organize and track your projects with collaborative tools and real-time updates.
            </p>
          </div>

          <div className={styles.card}>
            <h3>📬 Messaging</h3>
            <p>
              Stay connected with integrated messaging capabilities built with Rust for performance.
            </p>
          </div>
        </div>

        <div className={styles.ctas}>
          <a
            className={styles.primary}
            href="https://nextjs.org/docs"
            target="_blank"
            rel="noopener noreferrer"
          >
            View Documentation
          </a>
          <Button appName="web-dashboard" className={styles.secondary}>
            Get Started
          </Button>
        </div>
      </main>

      <footer className={styles.footer}>
        <span>Built with Turborepo 🏎️</span>
        <span>•</span>
        <a
          href="https://turborepo.com"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn more about Turborepo →
        </a>
      </footer>
    </div>
  );
}






