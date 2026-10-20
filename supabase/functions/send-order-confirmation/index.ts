import { serve } from 'https://deno.land/std@0.224.0/http/server.ts';

serve(async (req) => {
  if (req.method !== 'POST') return new Response('Method not allowed', { status: 405 });
  const { email, order_id, order, total, items } = await req.json();
  if (!email || !order_id) return Response.json({ error: 'Missing order email details' }, { status: 400 });

  const rows = (items ?? []).map((item: { product_name: string; quantity: number; line_total: number }) =>
    `<tr><td>${item.product_name}</td><td>${item.quantity}</td><td>₹${Number(item.line_total).toLocaleString('en-IN')}</td></tr>`).join('');
  const html = `<h2>Pahalgam Delivery order #${order_id}</h2><p>Thanks for your order. We’ll contact you before delivery.</p><table><tr><th>Item</th><th>Qty</th><th>Total</th></tr>${rows}</table><p><strong>Total: ₹${Number(total).toLocaleString('en-IN')}</strong></p>`;
  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { Authorization: `Bearer ${Deno.env.get('RESEND_API_KEY')}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ from: Deno.env.get('ORDER_EMAIL_FROM') ?? 'Pahalgam Delivery <orders@your-domain.com>', to: [email], subject: `Order #${order_id} confirmed`, html }),
  });
  if (!response.ok) return Response.json({ error: await response.text() }, { status: 502 });
  return Response.json({ ok: true });
});
