import { spawn } from 'node:child_process';
import { chromium } from 'playwright';
import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';

const HOST = '127.0.0.1';
const PORT = 4173;
const URL = `http://${HOST}:${PORT}`;
const OUTPUT = path.resolve(process.cwd(), 'interface.png');

const wait = ms => new Promise(resolve => setTimeout(resolve, ms));

async function waitForServer(url, timeoutMs = 20000) {
  const start = Date.now();
  while (Date.now() - start < timeoutMs) {
    try {
      const response = await fetch(url, { method: 'GET' });
      if (response.ok) return;
    } catch {
      // ignore while server is booting
    }
    await wait(250);
  }
  throw new Error(`Vite server did not start within ${timeoutMs}ms`);
}

const viteProcess = spawn(
  'pnpm',
  ['dev', '--host', HOST, '--port', String(PORT), '--strictPort'],
  {
    cwd: process.cwd(),
    stdio: 'ignore',
    shell: process.platform === 'win32',
  }
);

async function run() {
  try {
    await waitForServer(URL);

    const browser = await chromium.launch({ headless: true });
    const page = await browser.newPage({ viewport: { width: 1920, height: 1080 } });
    await page.goto(URL, { waitUntil: 'networkidle' });

    const menu = page.locator('div.fixed.top-0.right-0.h-full').first();
    await menu.waitFor({ state: 'visible', timeout: 10000 });
    const box = await menu.boundingBox();
    if (!box) {
      throw new Error('Could not determine UI bounds for screenshot');
    }

    await fs.rm(OUTPUT, { force: true });
    await page.screenshot({
      path: OUTPUT,
      type: 'png',
      omitBackground: true,
      clip: {
        x: box.x,
        y: box.y,
        width: box.width,
        height: box.height,
      },
    });

    await browser.close();
    console.log(`PNG exported: ${OUTPUT}`);
  } finally {
    viteProcess.kill();
  }
}

run().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
